class StringEditors {
  String truncateEventName(String eventName) {
    const int maxLength = 20;
    if (eventName.length > maxLength) {
      return '${eventName.substring(0, maxLength)}...';
    }
    return eventName;
  }


  String httpsAdder(String url) {
    if(!url.startsWith("http://") && !url.startsWith("https://")) {
      return "https://$url";
    }
    return url;
  }
}