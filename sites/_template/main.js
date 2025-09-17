document.addEventListener('DOMContentLoaded', () => {
  const el = document.createElement('p');
  el.textContent = `Deployed at ${new Date().toLocaleString()}`;
  document.querySelector('main')?.appendChild(el);
});

