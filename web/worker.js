self.onmessage = function(event) {
  // Example task: Check network status
  if (event.data === 'checkNetworkStatus') {
    self.postMessage(navigator.onLine);
  }

  // Example task: Sync with server
  if (event.data === 'syncWithServer') {
    // Implement server sync logic here
    self.postMessage('Server sync completed');
  }
};