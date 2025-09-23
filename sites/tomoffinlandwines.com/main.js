document.addEventListener('DOMContentLoaded', () => {
  const el = document.createElement('p');
  el.textContent = `Hello from JS. Time: ${new Date().toLocaleString()}`;
  document.querySelector('main')?.appendChild(el);
});

