(function () {

  const GITHUB_URL = "https://thejasenapps.github.io/reachx_embed/";

  const currentScript = document.currentScript;
  const INSTITUTION_ID = currentScript?.getAttribute("data-institution-id") || "";

  /* ---------- RELIABLE MOBILE DETECTION ---------- */

  function isMobileDevice() {
    return (
      /Android|iPhone|iPad|iPod|Opera Mini|IEMobile|WPDesktop/i.test(navigator.userAgent) ||
      window.innerWidth < 768 ||
      ("ontouchstart" in window && window.innerWidth < 1024)
    );
  }

  const isMobile = isMobileDevice();

  /* ---------- CREATE SHADOW ROOT ---------- */

  const host = document.createElement("div");
  const shadow = host.attachShadow({ mode: "open" });
  document.body.appendChild(host);

  shadow.innerHTML = `
    <style>

      :host { all: initial; }

      #btn {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 65px;
        height: 65px;
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
        transition: transform .2s ease;
      }

      #btn:hover {
        transform: scale(1.05);
      }

      #container {
        position: fixed;
        bottom: 110px;
        right: 30px;
        width: 380px;
        height: 720px;
        max-height: 90vh;
        background: white;
        border-radius: 16px;
        display: none;
        box-shadow: 0 10px 40px rgba(0,0,0,0.35);
        z-index: 2147483647;
        overflow: hidden;
        animation: fadeIn .25s ease;
      }

      #close {
        position: absolute;
        top: 10px;
        right: 10px;
        background: #fb4c4c;
        color: white;
        border: none;
        border-radius: 50%;
        width: 30px;
        height: 30px;
        cursor: pointer;
        z-index: 2;
      }

      #flutter-target {
        width: 100%;
        height: 100%;
      }

      @keyframes fadeIn {
        from {opacity:0; transform:translateY(20px);}
        to {opacity:1; transform:translateY(0);}
      }

    </style>

    <button id="btn">Book</button>

    <div id="container">
      <button id="close">×</button>
      <div id="flutter-target"></div>
    </div>
  `;

  const btn = shadow.getElementById("btn");
  const container = shadow.getElementById("container");
  const close = shadow.getElementById("close");
  const target = shadow.getElementById("flutter-target");

  /* ---------- MOBILE FULLSCREEN MODE ---------- */

  if (isMobile) {

    btn.style.width = "75px";
    btn.style.height = "75px";
    btn.style.fontSize = "18px";
    btn.style.bottom = "20px";
    btn.style.right = "20px";

    container.style.width = "100vw";
    container.style.height = "100vh";
    container.style.bottom = "0";
    container.style.right = "0";
    container.style.borderRadius = "0";

  }

  /* ---------- LOAD FLUTTER ---------- */

  let isLoaded = false;

  const script = document.createElement("script");
  script.src = GITHUB_URL + "flutter_embed.js";
  document.head.appendChild(script);

  /* ---------- OPEN WIDGET ---------- */

  btn.onclick = () => {

    container.style.display = "block";

    if (!isLoaded && window.FlutterEmbed) {

      window.FlutterEmbed.init({
        container: target,
        appUrl: GITHUB_URL,
        initialArgs: {
          institutionId: INSTITUTION_ID
        }
      });

      isLoaded = true;
    }
  };

  /* ---------- CLOSE WIDGET ---------- */

  close.onclick = () => {
    container.style.display = "none";
  };

})();
