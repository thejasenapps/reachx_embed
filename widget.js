(function () {

  const GITHUB_URL = "https://thejasenapps.github.io/reachx_embed/";

  const currentScript = document.currentScript;
  const INSTITUTION_ID = currentScript?.getAttribute("data-institution-id") || "";

  const host = document.createElement('div');
  const shadow = host.attachShadow({ mode: 'open' });
  document.body.appendChild(host);

  shadow.innerHTML = `
    <style>
      :host { all: initial; } 
      #btn {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: #1976D2;
        color: white;
        cursor: pointer;
        font-size: 15px;
        border: none;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        z-index: 2147483647;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      
      #container {
        position: fixed; bottom: 100px; right: 30px; width: 380px; height: 800px;
        background: white; border-radius: 15px; display: none;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3); z-index: 2147483647; overflow: hidden;
      }
      #close {
        position: absolute; top: 10px; right: 10px; background: #fb4c4c;
        color: white; border: none; border-radius: 50%; width: 25px; height: 25px;
        cursor: pointer; z-index: 2;
      }
      #flutter-target { width: 100%; height: 100%; }

      @media (max-width: 600px) {

        #btn {
          width: 75px;
          height: 75px;
          font-size: 24px;
          bottom: 20px;
          right: 20px;
        }

        #container {
          width: 92vw;
          height: 70vh;
          right: 4vw;
          bottom: 110px;
          border-radius: 18px;
        }
      }
    </style>

    <button id="btn">Book</button>

    <div id="container">
      <button id="close">×</button>
      <div id="flutter-target"></div>
    </div>
  `;

  const btn = shadow.getElementById('btn');
  const container = shadow.getElementById('container');
  const close = shadow.getElementById('close');
  const target = shadow.getElementById('flutter-target');

  let isLoaded = false;

  const script = document.createElement('script');
  script.src = GITHUB_URL + "flutter_embed.js";
  document.head.appendChild(script);

  btn.onclick = () => {
    container.style.display = 'block';

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
    container.style.display = 'none';
  };

})();
