// TimeLog Quick Entry - Background Service Worker

const DEFAULT_APP_URL = "http://localhost:8080/timesheet.html";

// Create context menu on install
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "timelog-entry",
    title: "Create TimeLog entry",
    contexts: ["selection"]
  });
});

// Handle context menu click
chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "timelog-entry") {
    const selectedText = info.selectionText || "";

    chrome.storage.sync.get({ appUrl: DEFAULT_APP_URL }, (settings) => {
      const appUrl = settings.appUrl || DEFAULT_APP_URL;
      const encoded = encodeURIComponent(selectedText.trim().substring(0, 300));
      const url = `${appUrl}?task=${encoded}&hours=1&popup=1`;

      chrome.windows.create({
        url: url,
        type: "popup",
        width: 520,
        height: 660,
        left: Math.round((screen.width - 520) / 2),
        top: 80
      });
    });
  }
});
