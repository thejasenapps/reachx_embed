(function () {

  /* ─────────────────────────────────────────────
     CONFIG
  ───────────────────────────────────────────── */
  const GITHUB_URL    = "https://thejasenapps.github.io/reachx_embed/";
  const BUTTON_LABEL  = "Talk to Founders";
  const BRAND_COLOR   = "#1976D2";
  const CLOSE_COLOR   = "#fb4c4c";

  /* ─────────────────────────────────────────────
     INSTITUTION ID  (from <script data-institution-id="…">)
  ───────────────────────────────────────────── */
  const currentScript  = document.currentScript;
  const INSTITUTION_ID = currentScript?.getAttribute("data-institution-id") || "";

  /* ─────────────────────────────────────────────
     BUILD IFRAME URL  — all params passed as
     query-string so Flutter can read them via
     window.location.search (no cross-origin postMessage needed)
  ───────────────────────────────────────────── */

  /**
   * Normalises an origin so that www-prefixed domains shed the subdomain.
   * Only applies when the hostname starts with "www.".
   *
   * Examples:
   *   https://www.enapp.in   → https://enapp.in
   *   https://www.foo.co.uk  → https://foo.co.uk
   *   https://app.enapp.in   → https://app.enapp.in  (unchanged — not www)
   *   https://enapp.in       → https://enapp.in      (unchanged — no www)
   */
  function normaliseOrigin(origin) {
    console.group("[ReachX] normaliseOrigin()");
    console.log("  ↳ Input origin         :", origin);
    try {
      const url = new URL(origin);
      console.log("  ↳ Parsed hostname      :", url.hostname);

      if (url.hostname.startsWith("www.")) {
        url.hostname = url.hostname.slice(4); // drop "www."
        console.log("  ↳ www. detected        : YES — stripped");
        console.log("  ↳ Normalised hostname  :", url.hostname);
      } else {
        console.log("  ↳ www. detected        : NO  — hostname unchanged");
      }

      const result = url.origin;
      console.log("  ↳ Final origin returned:", result);
      console.groupEnd();
      return result;
    } catch (err) {
      console.warn("  ↳ Failed to parse origin — returning as-is.", err);
      console.groupEnd();
      return origin;
    }
  }

  function buildIframeSrc() {
    console.group("[ReachX] buildIframeSrc()");
    console.log("  ↳ Raw window.location.origin :", window.location.origin);
    console.log("  ↳ Raw window.location.href   :", window.location.href);
    console.log("  ↳ INSTITUTION_ID             :", INSTITUTION_ID || "(none)");

    const normalisedOrigin = normaliseOrigin(window.location.origin);

    const params = new URLSearchParams({
      institutionId  : INSTITUTION_ID,
      referrerUrl    : window.location.href,
      referrerOrigin : normalisedOrigin,
    });

    const base = GITHUB_URL.replace(/\/?$/, "/");
    const finalSrc = base + "?" + params.toString();

    console.log("  ↳ referrerOrigin passed      :", normalisedOrigin);
    console.log("  ↳ Final iframe src           :", finalSrc);
    console.groupEnd();
    return finalSrc;
  }

  /* ─────────────────────────────────────────────
     MOBILE DETECTION
  ───────────────────────────────────────────── */
  function isMobileDevice() {
    return (
      /Android|iPhone|iPad|iPod|Opera Mini|IEMobile/i.test(navigator.userAgent) ||
      window.innerWidth < 768 ||
      ("ontouchstart" in window && window.innerWidth < 1024)
    );
  }
  const isMobile = isMobileDevice();

  /* ─────────────────────────────────────────────
     SHADOW DOM HOST
  ───────────────────────────────────────────── */
  const host   = document.createElement("div");
  host.id      = "reachx-embed-host";
  const shadow = host.attachShadow({ mode: "open" });
  document.body.appendChild(host);

  /* ─────────────────────────────────────────────
     STYLES
  ───────────────────────────────────────────── */
  const style = document.createElement("style");
  style.textContent = `
    :host { all: initial; }

    /* ── FAB button ── */
    #btn {
      position      : fixed;
      bottom        : 25px;
      left          : 25px;
      width         : 100px;
      height        : 100px;
      border-radius : 50%;
      background    : ${BRAND_COLOR};
      color         : white;
      cursor        : pointer;
      font-family   : sans-serif;
      font-size     : 14px;
      font-weight   : 700;
      border        : none;
      box-shadow    : 0 6px 20px rgba(0,0,0,0.30);
      z-index       : 2147483647;
      display       : flex;
      align-items   : center;
      justify-content: center;
      text-align    : center;
      line-height   : 1.25;
      padding       : 10px;
      word-break    : break-word;
      transition    : transform 0.15s ease, box-shadow 0.15s ease;
      -webkit-font-smoothing: antialiased;
    }
    #btn:hover {
      transform  : scale(1.06);
      box-shadow : 0 10px 28px rgba(0,0,0,0.35);
    }
    #btn:active { transform: scale(0.97); }

    /* ── Popup container ── */
    #container {
      position     : fixed;
      bottom       : 140px;
      left         : 30px;
      width        : 28vw;
      height       : 80vh;
      min-width    : 320px;
      max-width    : 420px;
      min-height   : 500px;
      max-height   : 90vh;
      background   : white;
      border-radius: 16px;
      display      : none;
      box-shadow   : 0 12px 48px rgba(0,0,0,0.30);
      z-index      : 2147483647;
      overflow     : hidden;
      overscroll-behavior: contain;
      /* open / close animation */
      transform-origin: bottom left;
      animation    : none;
    }
    #container.opening {
      animation: popIn 0.22s cubic-bezier(0.34,1.56,0.64,1) forwards;
    }
    @keyframes popIn {
      from { opacity: 0; transform: scale(0.85) translateY(12px); }
      to   { opacity: 1; transform: scale(1)    translateY(0);    }
    }

    /* ── Close button ── */
    #close {
      position     : absolute;
      top          : 10px;
      right        : 12px;
      background   : ${CLOSE_COLOR};
      color        : white;
      border       : none;
      border-radius: 50%;
      width        : 30px;
      height       : 30px;
      font-size    : 18px;
      line-height  : 1;
      cursor       : pointer;
      z-index      : 3;
      display      : flex;
      align-items  : center;
      justify-content: center;
      transition   : transform 0.12s ease, background 0.12s ease;
    }
    #close:hover  { background: #e03333; transform: scale(1.1); }
    #close:active { transform: scale(0.93); }

    /* ── Loader overlay ── */
    #loader {
      position        : absolute;
      inset           : 0;
      display         : flex;
      flex-direction  : column;
      align-items     : center;
      justify-content : center;
      gap             : 14px;
      background      : white;
      z-index         : 2;
      transition      : opacity 0.3s ease;
    }
    #loader.hidden {
      opacity        : 0;
      pointer-events : none;
    }
    .spinner {
      width        : 40px;
      height       : 40px;
      border       : 4px solid #e0e0e0;
      border-top   : 4px solid ${BRAND_COLOR};
      border-radius: 50%;
      animation    : spin 0.9s linear infinite;
    }
    .loader-text {
      font-family : sans-serif;
      font-size   : 13px;
      color       : #9e9e9e;
      letter-spacing: 0.02em;
    }
    @keyframes spin {
      from { transform: rotate(0deg); }
      to   { transform: rotate(360deg); }
    }

    /* ── iframe ── */
    #flutter-iframe {
      width        : 100%;
      height       : 100%;
      border       : none;
      display      : block;
      border-radius: 16px;
    }

    /* ════════════════════════════
       MOBILE OVERRIDES
    ════════════════════════════ */
    @media (max-width: 767px) {
      #btn {
        width        : 88px;
        height       : 88px;
        font-size    : 13px;
        bottom       : 20px;
        left         : 20px;
      }
      #container {
        top          : 20px;
        left         : 0;
        right        : 0;
        bottom       : 0;
        width        : 100vw;
        height       : calc(100dvh - 20px);
        max-width    : 100vw;
        max-height   : calc(100dvh - 20px);
        min-width    : unset;
        min-height   : unset;
        border-radius: 16px 16px 0 0;
        transform-origin: bottom center;
      }
      #container.opening {
        animation: slideUp 0.28s cubic-bezier(0.34,1.4,0.64,1) forwards;
      }
      @keyframes slideUp {
        from { opacity: 0; transform: translateY(40px); }
        to   { opacity: 1; transform: translateY(0);    }
      }
      #close {
        width  : 36px;
        height : 36px;
        top    : 12px;
        right  : 12px;
      }
      .spinner { width: 48px; height: 48px; }
    }
  `;
  shadow.appendChild(style);

  /* ─────────────────────────────────────────────
     MARKUP
  ───────────────────────────────────────────── */
  const markup = document.createElement("div");
  markup.innerHTML = `
    <button id="btn" aria-label="${BUTTON_LABEL}">${BUTTON_LABEL}</button>

    <div id="container" role="dialog" aria-modal="true" aria-label="ReachX Chat">

      <button id="close" aria-label="Close chat">&#x2715;</button>

      <!-- Loader shown until iframe fires load event -->
      <div id="loader">
        <div class="spinner"></div>
        <span class="loader-text">Loading…</span>
      </div>

      <!--
        KEY CHANGES vs original:
        ┌────────────────────────────────────────────────────────┐
        │  • Flutter runs inside an <iframe>                     │
        │  • iframe has its OWN origin (github.io)              │
        │  • Firebase / reCAPTCHA / AppCheck run in that origin  │
        │  • No cross-origin DOM pollution from parent site      │
        │  • sandbox flags grant exactly what Flutter needs      │
        └────────────────────────────────────────────────────────┘

        sandbox flags explained:
          allow-scripts          — Flutter JS must run
          allow-same-origin      — Firebase needs localStorage / IndexedDB
          allow-forms            — form submissions inside app
          allow-popups           — OAuth / external link flows
          allow-popups-to-escape-sandbox — popups from iframe not sandboxed
          allow-modals           — alert / confirm dialogs if needed
      -->
      <iframe
        id="flutter-iframe"
        title="ReachX"
        loading="lazy"
        allow="camera; microphone; clipboard-write"
        sandbox="allow-scripts allow-same-origin allow-forms allow-popups allow-popups-to-escape-sandbox allow-modals"
      ></iframe>

    </div>
  `;
  shadow.appendChild(markup);

  /* ─────────────────────────────────────────────
     ELEMENT REFS
  ───────────────────────────────────────────── */
  const btn     = shadow.getElementById("btn");
  const container = shadow.getElementById("container");
  const closeBtn  = shadow.getElementById("close");
  const loader    = shadow.getElementById("loader");
  const iframe    = shadow.getElementById("flutter-iframe");

  /* ─────────────────────────────────────────────
     IFRAME LOAD EVENT  — hide loader when ready
  ───────────────────────────────────────────── */
  iframe.addEventListener("load", () => {
    console.log("[ReachX] iframe 'load' event fired — waiting 800ms for Flutter first frame…");
    setTimeout(() => {
      loader.classList.add("hidden");
      console.log("[ReachX] Loader hidden — Flutter should be visible now.");
    }, 800);
  });

  /* ─────────────────────────────────────────────
     LAZY SRC — only set once, on first open
     (avoids loading Flutter before user needs it)
  ───────────────────────────────────────────── */
  let iframeInitialised = false;

  function ensureIframeLoaded() {
    if (iframeInitialised) {
      console.log("[ReachX] ensureIframeLoaded() → already initialised, skipping.");
      return;
    }
    iframeInitialised = true;
    console.group("[ReachX] ensureIframeLoaded() → first open");
    loader.classList.remove("hidden");
    const src = buildIframeSrc();
    iframe.src = src;
    console.log("  ↳ iframe.src set to:", src);
    console.groupEnd();
  }

  /* ─────────────────────────────────────────────
     OPEN / CLOSE
  ───────────────────────────────────────────── */
  function openChat() {
    console.log("[ReachX] openChat() called");
    ensureIframeLoaded();
    container.style.display = "block";
    requestAnimationFrame(() => {
      container.classList.add("opening");
    });
    btn.setAttribute("aria-expanded", "true");
    console.log("[ReachX] Chat container opened.");
  }

  function closeChat() {
    console.log("[ReachX] closeChat() called — container hidden.");
    container.style.display = "none";
    container.classList.remove("opening");
    btn.setAttribute("aria-expanded", "false");
  }

  btn.addEventListener("click", () => {
    const isOpen = container.style.display === "block";
    isOpen ? closeChat() : openChat();
  });

  closeBtn.addEventListener("click", closeChat);

  /* ─────────────────────────────────────────────
     KEYBOARD  — close on Escape
  ───────────────────────────────────────────── */
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && container.style.display === "block") {
      closeChat();
    }
  });

  /* ─────────────────────────────────────────────
     OPTIONAL: listen for messages FROM the Flutter app
     (e.g. Flutter posts { type: "reachx:close" } to close the widget)
  ───────────────────────────────────────────── */
  window.addEventListener("message", (event) => {
    // Only accept messages from our GitHub Pages origin
    const expectedOrigin = new URL(GITHUB_URL).origin;
    if (event.origin !== expectedOrigin) return;

    const data = event.data;
    if (!data || typeof data !== "object") return;

    console.log("[ReachX] postMessage received from iframe:", data);
    switch (data.type) {
      case "reachx:close":
        console.log("[ReachX]   ↳ type: reachx:close — closing chat.");
        closeChat();
        break;
      case "reachx:ready":
        console.log("[ReachX]   ↳ type: reachx:ready — Flutter signalled render complete, hiding loader.");
        loader.classList.add("hidden");
        break;
      default:
        console.log("[ReachX]   ↳ Unhandled message type:", data.type);
        break;
    }
  });

})();
