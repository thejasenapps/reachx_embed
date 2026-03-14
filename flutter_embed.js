(function () {
  window.FlutterEmbed = {
    init: function (config) {
      const container = (typeof config.container === 'string') 
        ? document.getElementById(config.container) 
        : config.container;

      if (!container) {
        console.error("FlutterEmbed: Container not found");
        return;
      }

      const appUrl = config.appUrl;
      
      // 1. Capture the arguments (like institutionId) passed from your loader
      const args = config.initialArgs || {};

      const flutterScript = document.createElement("script");
      flutterScript.src = appUrl + "flutter.js";

      flutterScript.onload = function () {
        _flutter.loader.loadEntrypoint({
          entrypointUrl: appUrl + "main.dart.js",
          onEntrypointLoaded: async function (engineInitializer) {
            const appRunner = await engineInitializer.initializeEngine({
              hostElement: container,
              assetBase: appUrl,
            });

            // 3. Store the ID globally so Flutter can grab it easily
            window.REACHX_INST_ID = args.institutionId;

            await appRunner.runApp();
          }
        });
      };

      document.body.appendChild(flutterScript);
    }
  };
})();
