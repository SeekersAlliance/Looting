export const injectHandler = (elementId, callback) => {
  const element = document.getElementById(elementId);
  if (!element) return;
  element.onclick = callback;
};
