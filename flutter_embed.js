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

      const appUrl  = config.appUrl;
      const args    = config.initialArgs || {};

      // ── Debug: log exactly what was received ──
      console.group("[ReachX] FlutterEmbed.init()");
      console.log("  ↳ institutionId  :", args.institutionId  || "(none)");
      console.log("  ↳ referrerUrl    :", args.referrerUrl    || "(none)");
      console.log("  ↳ referrerOrigin :", args.referrerOrigin || "(none)");
      console.groupEnd();

      const flutterScript = document.createElement("script");
      flutterScript.src = appUrl + "flutter.js";

      flutterScript.onload = function () {
        _flutter.loader.loadEntrypoint({
          entrypointUrl: appUrl + "main.dart.js",
          onEntrypointLoaded: async function (engineInitializer) {
            const appRunner = await engineInitializer.initializeEngine({
              hostElement: container,
              assetBase : appUrl,
            });

            window.REACHX_INST_ID = args.institutionId;
            window.DOMAIN_URL     = args.referrerOrigin; // ✅ normalised origin (www. stripped)
            window.REFERRER_URL   = args.referrerUrl;    // full href, kept separately if needed

            console.log("[ReachX] Globals set before runApp()");
            console.log("  ↳ window.REACHX_INST_ID :", window.REACHX_INST_ID);
            console.log("  ↳ window.DOMAIN_URL      :", window.DOMAIN_URL);
            console.log("  ↳ window.REFERRER_URL    :", window.REFERRER_URL);

            await appRunner.runApp();
          }
        });
      };

      document.body.appendChild(flutterScript);
    }
  };
})();
