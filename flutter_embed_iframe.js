(function () {
  window.FlutterEmbed = {
    init: function (config) {

      const container =
        typeof config.container === "string"
          ? document.getElementById(config.container)
          : config.container;

      if (!container) {
        console.error("FlutterEmbed: Container not found");
        return;
      }

      const appUrl = config.appUrl;
      const args = config.initialArgs || {};

      const params = new URLSearchParams(args).toString();
      const iframeSrc = params ? `${appUrl}?${params}` : appUrl;

      const iframe = document.createElement("iframe");
      iframe.src = iframeSrc;

      iframe.style.width = "100%";
      iframe.style.height = "100%";
      iframe.style.border = "none";

      iframe.allow = "camera; microphone; autoplay; fullscreen";

      container.innerHTML = "";
      container.appendChild(iframe);
    },
  };
})();
