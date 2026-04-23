(function () {

  const GITHUB_URL = "https://thejasenapps.github.io/reachx_embed/";

  const currentScript = document.currentScript;
  const INSTITUTION_ID = currentScript?.getAttribute("data-institution-id") || "";


  function isMobileDevice() {
    return (
      /Android|iPhone|iPad|iPod|Opera Mini|IEMobile/i.test(navigator.userAgent) ||
      window.innerWidth < 768 ||
      ("ontouchstart" in window && window.innerWidth < 1024)
    );
  }

  const isMobile = isMobileDevice();


  const host = document.createElement("div");
  const shadow = host.attachShadow({ mode: "open" });
  document.body.appendChild(host);

  shadow.innerHTML = `
    <style>

      :host { all: initial; }

      #btn {
        position: fixed;
        bottom: 25px;
        left: 25px;
        width: 70px;
        height: 70px;
        border-radius: 50%;
        background: #1976D2;
        color: white;
        cursor: pointer;
        font-size: 16px;
        border: none;
        box-shadow: 0 6px 20px rgba(0,0,0,0.25);
        z-index: 2147483647;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        line-height: 1.2;
        padding: 8px;
        word-break: break-word;
      }

      #container {
        position: fixed;
        bottom: 110px;
        left: 30px;
        width: 28vw;
        height: 80vh;
        min-width: 320px;
        max-width: 420px;
        min-height: 500px;
        max-height: 90vh;
        background: white;
        border-radius: 16px;
        display: none;
        box-shadow: 0 10px 40px rgba(0,0,0,0.35);
        z-index: 2147483647;
        overflow: hidden;
        overscroll-behavior: contain;
      }

      #close {
        position: absolute;
        top: 12px;
        right: 16px;
        background: #fb4c4c;
        color: white;
        border: none;
        border-radius: 50%;
        width: 30px;
        height: 30px;
        cursor: pointer;
        z-index: 3;
      }

      #loader{
        position:absolute;
        inset:0;
        display:flex;
        align-items:center;
        justify-content:center;
        background:white;
        z-index:2;
      }

      .spinner{
        width:40px;
        height:40px;
        border:4px solid #e0e0e0;
        border-top:4px solid #1976D2;
        border-radius:50%;
        animation:spin 1s linear infinite;
      }

      #flutter-wrapper {
        width: 100%;
        height: 100%;
        overflow: hidden;
        overscroll-behavior: contain;
      }

      #flutter-target {
        width: 100%;
        height: 100%;
      }

      @keyframes spin{
        from{transform:rotate(0deg);}
        to{transform:rotate(360deg);}
      }

    </style>

    <button id="btn">Talk to Founders</button>

    <div id="container">
      <button id="close">×</button>
      <div id="flutter-wrapper">
        <div id="loader">
          <div class="spinner"></div>
        </div>
        <div id="flutter-target"></div>
      </div>
    </div>
  `;

  const btn = shadow.getElementById("btn");
  const container = shadow.getElementById("container");
  const close = shadow.getElementById("close");
  const target = shadow.getElementById("flutter-target");
  const wrapper = shadow.getElementById("flutter-wrapper");
  const loader = shadow.getElementById("loader");
  const spinner = shadow.querySelector(".spinner");

  /* ---------- MOBILE FULLSCREEN ---------- */

  if (isMobile) {

    // Button — pill shape to accommodate longer text, bottom-right
    btn.style.width = "auto";
    btn.style.height = "40px";
    btn.style.fontSize = "11px";
    btn.style.fontWeight = "600";
    btn.style.borderRadius = "20px";
    btn.style.padding = "0 14px";
    btn.style.bottom = "16px";
    btn.style.right = "16px";
    btn.style.left = "auto";
    btn.style.whiteSpace = "nowrap";
    btn.style.boxShadow = "0 4px 12px rgba(0,0,0,0.25)";

    // Close button — large enough for touch
    close.style.width = "36px";
    close.style.height = "36px";
    close.style.fontSize = "20px";
    close.style.top = "12px";
    close.style.right = "12px";

    // Container — full screen, edge-to-edge in both axes
    container.style.position = "fixed";
    container.style.top = "0";
    container.style.left = "0";
    container.style.right = "0";
    container.style.bottom = "0";
    container.style.width = "100vw";
    container.style.height = "100vh";
    container.style.maxWidth = "100vw";
    container.style.maxHeight = "100vh";
    container.style.minWidth = "unset";
    container.style.minHeight = "unset";
    container.style.borderRadius = "0";
    container.style.boxSizing = "border-box";
    container.style.margin = "0";
    container.style.padding = "0";

    spinner.style.width = "48px";
    spinner.style.height = "48px";
    spinner.style.borderWidth = "4px";

  }

  /* ---------- LOAD FLUTTER ---------- */

  let isLoaded = false;

  const script = document.createElement("script");
  script.src = GITHUB_URL + "flutter_embed.js";
  document.head.appendChild(script);

  /* ---------- SCALE FLUTTER APP ---------- */

  function scaleFlutter() {

    if (!isMobile) return;

    const vw = window.innerWidth;
    const vh = window.innerHeight;

    // Scale flutter content to fill the full viewport width
    const baseWidth = 500;
    const scale = vw / baseWidth;

    target.style.transform = "scale(" + scale + ")";
    target.style.transformOrigin = "top left";
    target.style.width = baseWidth + "px";
    target.style.height = (vh / scale) + "px";
  }

  window.addEventListener("resize", scaleFlutter);

  /* ---------- OPEN ---------- */

  btn.onclick = () => {

    const isOpen = container.style.display === "block";

    if(isOpen) {
      container.style.display = "none";
      return;
    }

    container.style.display = "block";
    loader.style.display = "flex";

    if (!isLoaded && window.FlutterEmbed) {

      window.FlutterEmbed.init({
        container: target,
        appUrl: GITHUB_URL,
        initialArgs: {
          institutionId: INSTITUTION_ID,
          referrerUrl: window.location.href,
          referrerOrigin: window.location.origin
        }
      });

      isLoaded = true;

      setTimeout(() => {
        scaleFlutter();
        loader.style.display = "none";
      }, 5000);
    } else {
      loader.style.display = "none";
    }
  };

  /* ---------- CLOSE ---------- */

  close.onclick = () => {
    container.style.display = "none";
  };

})();
