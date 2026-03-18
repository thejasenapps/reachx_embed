
  /* ---------- Iframe ---------- */
(function () {

  const GITHUB_URL = "https://thejasenapps.github.io/reachx_embed/";

  const currentScript = document.currentScript;
  const INSTITUTION_ID = currentScript?.getAttribute("data-institution-id") || "";

  /* ---------- MOBILE DETECTION ---------- */

  function isMobileDevice() {
    return (
      /Android|iPhone|iPad|iPod|Opera Mini|IEMobile/i.test(navigator.userAgent) ||
      window.innerWidth < 768 ||
      ("ontouchstart" in window && window.innerWidth < 1024)
    );
  }

  const isMobile = isMobileDevice();

    /* ---------- FORCE VIEWPORT ---------- */

  if (isMobile) {
    let meta = document.querySelector("meta[name=viewport]");
    if (!meta) {
      meta = document.createElement("meta");
      meta.name = "viewport";
      meta.content = "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no";
      document.head.appendChild(meta);
    }
  }

  /* ---------- CREATE SHADOW ROOT ---------- */

  const host = document.createElement("div");
  const shadow = host.attachShadow({ mode: "open" });
  document.body.appendChild(host);

  shadow.innerHTML = `
    <style>

      :host { all: initial; }

      #btn {
        position: fixed;
        bottom: 25px;
        right: 25px;
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
      }

      iframe {
        width: 100%;
        height: 100%;
        border: none;
      }

      @keyframes spin{
        from{transform:rotate(0deg);}
        to{transform:rotate(360deg);}
      }

    </style>

    <button id="btn">Book</button>

    <div id="container">
      <button id="close">×</button>
      <div id="flutter-wrapper">
        <div id="loader">
          <div class="spinner"></div>
        </div>
      </div>
    </div>
  `;

  const btn = shadow.getElementById("btn");
  const container = shadow.getElementById("container");
  const close = shadow.getElementById("close");
  const wrapper = shadow.getElementById("flutter-wrapper");
  const loader = shadow.getElementById("loader");
  const spinner = shadow.querySelector(".spinner");

  /* ---------- MOBILE FULLSCREEN ---------- */

  if (isMobile) {

    btn.style.width = "120px";
    btn.style.height = "120px";
    btn.style.fontSize = "28px";
    btn.style.bottom = "40px";
    btn.style.right = "40px";

    close.style.width = "60px";
    close.style.height = "60px";
    close.style.fontSize = "35px";

    container.style.width = "100vw";
    container.style.height = "100vh";
    container.style.bottom = "0";
    container.style.right = "0";
    container.style.borderRadius = "0";

    spinner.style.width = "80px";
    spinner.style.height = "80px";
    spinner.style.borderWidth = "6px";
  }

  /* ---------- IFRAME LOAD ---------- */

  let isLoaded = false;

  function createIframe() {

    const iframe = document.createElement("iframe");

    const params = new URLSearchParams({
      institutionId: INSTITUTION_ID
    });

    iframe.src = GITHUB_URL + "?" + params.toString();

    iframe.onload = () => {
      loader.style.display = "none";
    };

    wrapper.appendChild(iframe);
  }

  /* ---------- OPEN ---------- */

  btn.onclick = () => {

    container.style.display = "block";
    loader.style.display = "flex";

    if (isMobile) {
      document.body.style.overflow = "hidden";
    }

    if (!isLoaded) {
      createIframe();
      isLoaded = true;
    }
  };

  /* ---------- CLOSE ---------- */

  close.onclick = () => {
    container.style.display = "none";

     if (isMobile) {
      document.body.style.overflow = "";
    }
  };

})();
