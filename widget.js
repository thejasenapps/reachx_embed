(function () {

  const GITHUB_URL = "https://thejasenapps.github.io/reachx_embed/";

  const currentScript = document.currentScript;
  const INSTITUTION_ID = currentScript?.getAttribute("data-institution-id") || "";

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
      }

      #container {
        position: fixed;
        bottom: 110px;
        right: 30px;
        width: 380px;
        height: 700px;
        background: white;
        border-radius: 16px;
        display: none;
        box-shadow: 0 10px 30px rgba(0,0,0,0.35);
        z-index: 2147483647;
        overflow: hidden;
      }

      #close {
        position: absolute;
        top: 10px;
        right: 10px;
        background: #fb4c4c;
        color: white;
        border: none;
        border-radius: 50%;
        width: 28px;
        height: 28px;
        cursor: pointer;
        z-index: 2;
      }

      #flutter-target {
        width: 100%;
        height: 100%;
      }

      /* MOBILE RESPONSIVE */
      @media (max-width: 600px) {

        #btn {
          width: 80px;
          height: 80px;
          font-size: 20px;
          bottom: 20px;
          right: 20px;
        }

        #container {
          width: 94vw;
          height: 85vh;
          right: 3vw;
          bottom: 110px;
          border-radius: 20px;
        }

      }

      /* VERY SMALL PHONES */
      @media (max-width: 420px) {

        #container {
          width: 96vw;
          height: 88vh;
          right: 2vw;
        }

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

  let isLoaded = false;

  const script = document.createElement("script");
  script.src = GITHUB_URL + "flutter_embed.js";
  document.head.appendChild(script);

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

  close.onclick = () => {
    container.style.display = "none";
  };

})();
