// Dictionary
const dict = {
  ar: {
    appName: "استراحة العين",
    headline: "عيونك تستاهل راحة",
    subhead: "قاعدة 20-20-20: كل 20 دقيقة، انظر لشيء يبعد 20 قدماً لمدة 20 ثانية.",
    download: "تحميل مجاني",
    tryIt: "جربها الآن",
    pricing: "الأسعار",
    free: "مجاني",
    pro: "برو",
    comingSoon: "قريباً",
    priceFree: "$0",
    pricePro: "$4.99",
    featuresFree: [
      "تذكير 20-20-20",
      "تأثير التشويش",
      "مؤقت في شريط القوائم",
      "إيقاف مؤقت، غفوة، تخطي",
      "تشغيل عند بدء النظام",
      "عربي + إنجليزي"
    ],
    featuresPro: [
      "كل شيء في المجاني",
      "إحصائيات ورسوم بيانية أسبوعية",
      "أصوات تنبيه مخصصة",
      "تخصيص شكل التشويش",
      "وضع بومودورو",
      "تقارير شهرية"
    ],
    platformMac: "macOS 13+",
    platformSize: "~100 KB",
    platformAccount: "لا يتطلب حساب",
    phLink: "صفحة Product Hunt",
    featuresTitle: "المميزات الرئيسية",
    feature1Title: "قاعدة 20-20-20",
    feature1Desc: "تذكير ذكي كل 20 دقيقة للنظر بعيداً لمسافة 20 قدماً لمدة 20 ثانية.",
    feature2Title: "تأثير التشويش",
    feature2Desc: "شاشة تشويش لطيفة تجبرك على أخذ استراحة فعلية والابتعاد عن الشاشة.",
    feature3Title: "خفيف وسريع",
    feature3Desc: "يعمل بصمت في الخلفية دون استهلاك موارد جهازك.",
    langSwitch: "English"
  },
  en: {
    appName: "EyeBreak",
    headline: "Your Eyes Deserve a Break",
    subhead: "The 20-20-20 rule: Every 20 minutes, look at something 20 feet away for 20 seconds.",
    download: "Download Free",
    tryIt: "Try it now",
    pricing: "Pricing",
    free: "Free",
    pro: "Pro",
    comingSoon: "Coming Soon",
    priceFree: "$0",
    pricePro: "$4.99",
    featuresFree: [
      "20-20-20 reminders",
      "TV static overlay",
      "Menu bar timer",
      "Pause, snooze, skip",
      "Start at login",
      "Arabic + English"
    ],
    featuresPro: [
      "Everything in Free",
      "Weekly statistics & charts",
      "Custom alert sounds",
      "Customize overlay style",
      "Pomodoro mode",
      "Monthly reports"
    ],
    platformMac: "macOS 13+",
    platformSize: "~100 KB",
    platformAccount: "No account needed",
    phLink: "Product Hunt page",
    featuresTitle: "Key Features",
    feature1Title: "20-20-20 Rule",
    feature1Desc: "Smart reminders every 20 minutes to look 20 feet away for 20 seconds.",
    feature2Title: "Static Overlay",
    feature2Desc: "A gentle TV static overlay that forces you to take a real break.",
    feature3Title: "Light & Fast",
    feature3Desc: "Runs silently in the background without draining your system resources.",
    langSwitch: "العربية"
  }
};

let currentLang = 'ar';
const SVG_NS = 'http://www.w3.org/2000/svg';

function makeCheckIcon() {
  const svg = document.createElementNS(SVG_NS, 'svg');
  svg.setAttribute('viewBox', '0 0 24 24');
  svg.setAttribute('fill', 'none');
  svg.setAttribute('stroke', 'currentColor');
  svg.setAttribute('stroke-width', '2');
  svg.setAttribute('stroke-linecap', 'round');
  svg.setAttribute('stroke-linejoin', 'round');
  const poly = document.createElementNS(SVG_NS, 'polyline');
  poly.setAttribute('points', '20 6 9 17 4 12');
  svg.appendChild(poly);
  return svg;
}

function renderFeatureList(containerId, features) {
  const container = document.getElementById(containerId);
  container.textContent = '';
  features.forEach(text => {
    const li = document.createElement('li');
    li.appendChild(makeCheckIcon());
    const span = document.createElement('span');
    span.textContent = text;
    li.appendChild(span);
    container.appendChild(li);
  });
}

function applyLang(lang) {
  currentLang = lang;
  const t = dict[lang];

  document.documentElement.lang = lang;
  document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';

  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (t[key]) el.textContent = t[key];
  });

  renderFeatureList('features-free', t.featuresFree);
  renderFeatureList('features-pro', t.featuresPro);

  document.getElementById('lang-label').textContent = t.langSwitch;
}

document.getElementById('lang-toggle').addEventListener('click', () => {
  applyLang(currentLang === 'ar' ? 'en' : 'ar');
});

// TV Static animation
(function initStatic() {
  const canvas = document.getElementById('tv-static');
  const ctx = canvas.getContext('2d', { alpha: false });

  function resize() {
    canvas.width = window.innerWidth / 2;
    canvas.height = window.innerHeight / 2;
  }
  window.addEventListener('resize', resize);
  resize();

  function draw() {
    const w = canvas.width;
    const h = canvas.height;
    if (w > 0 && h > 0) {
      const idata = ctx.createImageData(w, h);
      const buffer32 = new Uint32Array(idata.data.buffer);
      for (let i = 0; i < buffer32.length; i++) {
        const noise = Math.random() * 255;
        buffer32[i] = (255 << 24) | (noise << 16) | (noise << 8) | noise;
      }
      ctx.putImageData(idata, 0, 0);
    }
    requestAnimationFrame(draw);
  }
  draw();
})();

// Scroll-based opacity
const staticCanvas = document.getElementById('tv-static');
window.addEventListener('scroll', () => {
  if (staticCanvas.classList.contains('full')) return;
  const total = document.documentElement.scrollHeight - document.documentElement.clientHeight;
  if (total <= 0) return;
  const scroll = document.documentElement.scrollTop / total;
  const opacity = 0.05 + Math.min(Math.max(scroll, 0), 1) * 0.10;
  staticCanvas.style.opacity = opacity;
});

// Try Now — full static for 5 seconds
document.getElementById('try-now-btn').addEventListener('click', () => {
  staticCanvas.classList.add('full');
  document.body.style.cursor = 'none';
  setTimeout(() => {
    staticCanvas.classList.remove('full');
    document.body.style.cursor = 'auto';
  }, 5000);
});

applyLang('ar');
