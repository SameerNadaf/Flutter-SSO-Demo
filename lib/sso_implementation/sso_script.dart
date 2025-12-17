class SSOScript {
  static const String script = '''
    (function() {
      const CREDENTIALS = {
        email: "dummyemail@gmail.com",
        password: "password123"
      };
      
      console.log("SSO Script Injected for " + window.location.hostname);

      function triggerEvents(element) {
        const events = ['input', 'change', 'blur', 'focus', 'keyup', 'keydown', 'keypress', 'click'];
        events.forEach(evt => {
            element.dispatchEvent(new Event(evt, { bubbles: true }));
        });
      }

      function isVisible(elem) {
          return !!( elem.offsetWidth || elem.offsetHeight || elem.getClientRects().length );
      }

      function clickButton(selector) {
          const btn = document.querySelector(selector);
          if (btn && isVisible(btn)) {
              console.log("Attempting to click button: " + selector);
              if (!btn.disabled) {
                  btn.click();
                  return true;
              } else {
                  console.log("Button is disabled, waiting...");
              }
          }
          return false;
      }

      function handlePersistence() {
          // 1. Uncheck "Remember me" checkboxes
          const rememberMeSelectors = [
              'input[name="rememberMe"]',
              'input[name="Kmsi"]', // Microsoft Keep me signed in
              'input[name="PersistentCookie"]',
              'input[name="remember"]',
              'input[type="checkbox"][value="true"]'
          ];

          rememberMeSelectors.forEach(selector => {
              const el = document.querySelector(selector);
              if (el && isVisible(el) && el.checked) {
                  console.log("Unchecking Remember Me: " + selector);
                  el.checked = false;
                  triggerEvents(el);
              }
          });

          // 2. Handle "Stay signed in?" pages (Microsoft specific)
          if (window.location.hostname.includes('login.microsoftonline.com')) {
              const noBtn = document.querySelector('#idBtn_Back');
              const heading = document.querySelector('.row.text-title');
              
              if (noBtn && isVisible(noBtn) && heading && heading.innerText.includes('Stay signed in?')) {
                   console.log("Found Microsoft 'Stay signed in?' page - Clicking No");
                   noBtn.click();
              }
          }
      }

      function attemptAutoFill() {
        handlePersistence();

        // --- 1. Email Handling ---
        const emailSelectors = [
            'input[type="email"]',
            'input[name="email"]', 
            'input[name="username"]',
            'input[name="loginfmt"]',
            'input[name="identifier"]',
            '#i0116'
        ];
        
        let emailFilled = false;
        for (let selector of emailSelectors) {
            const el = document.querySelector(selector);
            // If field exists, is visible, and EMPTY (or we want to force it)
            // Checking !el.value ensures we don't overwrite if user manually changed it, 
            // but for SSO we usually want to force it. Let's check if it's empty.
            if (el && isVisible(el) && !el.value) {
                console.log("Found Email Field: " + selector);
                el.value = CREDENTIALS.email;
                triggerEvents(el);
                emailFilled = true;
                break;
            }
        }

        // --- 2. Password Handling ---
        const passwordSelectors = [
            'input[type="password"]',
            'input[name="password"]',
            'input[name="passwd"]',
            '#i0118'
        ];

        let passwordFilled = false;
        for (let selector of passwordSelectors) {
            const el = document.querySelector(selector);
            if (el && isVisible(el) && !el.value) {
                console.log("Found Password Field: " + selector);
                el.value = CREDENTIALS.password;
                triggerEvents(el);
                passwordFilled = true;
                break;
            }
        }

        // --- 3. Submit Button Handling ---
        // We only click submit if we just filled something OR if we see a filled field and a button
        
        const submitSelectors = [
            '#idSIButton9', // Microsoft Next/Login
            '#identifierNext', // Google Email Next
            '#passwordNext', // Google Password Next
            '#passwordNext > div > button',
            'input[type="submit"]',
            'button[type="submit"]',
            'button[data-report-event="Signin_Submit"]',
            '#submit-button',
            '.VfPpkd-LgbsSe' // Generic Google Material button class (risky but fallback)
        ];

        // Only try to click if we are on a login flow
        // Check if we have a visible email or password field that is filled
        const hasFilledEmail = emailSelectors.some(s => {
            const el = document.querySelector(s);
            return el && isVisible(el) && el.value === CREDENTIALS.email;
        });

        const hasFilledPassword = passwordSelectors.some(s => {
             const el = document.querySelector(s);
             return el && isVisible(el) && el.value === CREDENTIALS.password;
        });

        if (hasFilledEmail || hasFilledPassword) {
            for (let selector of submitSelectors) {
                if (clickButton(selector)) {
                    // Don't break immediately, in case there are multiple buttons and we need to be specific
                    // But usually the first visible one is correct.
                    break;
                }
            }
        }
      }

      setInterval(attemptAutoFill, 1000);
    })();
  ''';
}
