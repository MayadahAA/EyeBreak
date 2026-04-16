// Language toggle
let currentLang = 'en';

function toggleLang() {
    currentLang = currentLang === 'en' ? 'ar' : 'en';

    document.querySelectorAll('[data-en]').forEach(el => {
        el.hidden = currentLang !== 'en';
    });
    document.querySelectorAll('[data-ar]').forEach(el => {
        el.hidden = currentLang !== 'ar';
    });

    document.documentElement.dir = currentLang === 'ar' ? 'rtl' : 'ltr';
    document.documentElement.lang = currentLang;
}

// TV Static animation for demo
function initStatic() {
    const canvas = document.getElementById('staticCanvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    const pixelSize = 6;

    function drawNoise() {
        const cols = Math.ceil(canvas.width / pixelSize);
        const rows = Math.ceil(canvas.height / pixelSize);

        for (let row = 0; row < rows; row++) {
            for (let col = 0; col < cols; col++) {
                const brightness = 15 + Math.floor(Math.random() * 60);
                ctx.fillStyle = `rgb(${brightness},${brightness},${brightness})`;
                ctx.fillRect(col * pixelSize, row * pixelSize, pixelSize, pixelSize);
            }
        }
    }

    setInterval(drawNoise, 200);
    drawNoise();
}

document.addEventListener('DOMContentLoaded', initStatic);
