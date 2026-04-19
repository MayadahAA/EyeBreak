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
    pressEscToSkip: "اضغط ESC للتخطي",
    tryHint: "↑ اضغط لتجربة استراحة ٥ ثواني الآن",
    howItWorks: "كيف يعمل التطبيق",
    step1Title: "يسكن في شريط القوائم",
    step1Desc: "أيقونة عين صغيرة في أعلى الشاشة، لا تزعج عملك.",
    step2Title: "مؤقت ذكي 20 دقيقة",
    step2Desc: "يعد تنازلياً في الخلفية، يمكنك إيقافه أو تأجيله في أي وقت.",
    step3Title: "شاشة تشويش للاستراحة",
    step3Desc: "لمدة 20 ثانية، الشاشة تصبح مملة فتضطر للنظر بعيداً.",
    nextBreak: "الاستراحة القادمة",
    waitlistLabel: "نبّهني لما يصير متاح",
    notify: "نبّهني",
    waitlistSuccess: "✓ تم! بنخبرك أول ما ينطلق",
    emailPlaceholder: "you@example.com",
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
    pressEscToSkip: "Press ESC to skip",
    tryHint: "↑ Click to try a 5-second break now",
    howItWorks: "How it Works",
    step1Title: "Lives in Your Menu Bar",
    step1Desc: "A tiny eye icon sits at the top of your screen. Never in the way.",
    step2Title: "Smart 20-Minute Timer",
    step2Desc: "Counts down silently in the background. Pause or snooze anytime.",
    step3Title: "TV Static Break Screen",
    step3Desc: "For 20 seconds, your screen becomes boring enough to make you look away.",
    nextBreak: "Next break",
    waitlistLabel: "Notify me when it's available",
    notify: "Notify me",
    waitlistSuccess: "✓ You're in! We'll email you at launch.",
    emailPlaceholder: "you@example.com",
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

  document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
    const key = el.getAttribute('data-i18n-placeholder');
    if (t[key]) el.setAttribute('placeholder', t[key]);
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

  let lastDraw = 0;
  function draw(ts) {
    // Throttle to ~8fps to match the app's 0.12s interval
    if (ts - lastDraw < 120) {
      requestAnimationFrame(draw);
      return;
    }
    lastDraw = ts;

    const w = canvas.width;
    const h = canvas.height;
    if (w > 0 && h > 0) {
      const idata = ctx.createImageData(w, h);
      const buffer32 = new Uint32Array(idata.data.buffer);

      // Match app exactly: dark gray range (6-42 of 255) in both modes
      for (let i = 0; i < buffer32.length; i++) {
        const noise = 6 + Math.floor(Math.random() * 37);
        buffer32[i] = (255 << 24) | (noise << 16) | (noise << 8) | noise;
      }
      ctx.putImageData(idata, 0, 0);
    }
    requestAnimationFrame(draw);
  }
  requestAnimationFrame(draw);
})();

// Scroll-based opacity
const staticCanvas = document.getElementById('tv-static');
window.addEventListener('scroll', () => {
  if (staticCanvas.classList.contains('full')) return;
  const total = document.documentElement.scrollHeight - document.documentElement.clientHeight;
  if (total <= 0) return;
  const scroll = document.documentElement.scrollTop / total;
  // Subtle at top (0.4), stronger as you scroll (0.85)
  const opacity = 0.4 + Math.min(Math.max(scroll, 0), 1) * 0.45;
  staticCanvas.style.opacity = opacity;
});

// Try Now — full static for 5 seconds (or ESC to skip)
const breakBg = document.getElementById('break-bg');
const breakHint = document.getElementById('break-hint');
let breakTimeout = null;

function endBreak() {
  breakBg.classList.remove('active');
  staticCanvas.classList.remove('full');
  breakHint.classList.remove('active');
  document.body.style.cursor = 'auto';
  if (breakTimeout) { clearTimeout(breakTimeout); breakTimeout = null; }
}

function startBreak() {
  breakBg.classList.add('active');
  staticCanvas.classList.add('full');
  breakHint.classList.add('active');
  document.body.style.cursor = 'none';
  breakTimeout = setTimeout(endBreak, 5000);
}

document.getElementById('try-now-btn').addEventListener('click', startBreak);
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && staticCanvas.classList.contains('full')) {
    endBreak();
  }
});

// Mini static canvas (for "How it works" step 3)
(function initMiniStatic() {
  const mini = document.getElementById('mini-static');
  if (!mini) return;
  const ctx = mini.getContext('2d', { alpha: false });

  function resize() {
    const rect = mini.getBoundingClientRect();
    mini.width = Math.max(1, Math.floor(rect.width / 2));
    mini.height = Math.max(1, Math.floor(rect.height / 2));
  }
  window.addEventListener('resize', resize);
  setTimeout(resize, 50);

  let last = 0;
  function draw(ts) {
    if (ts - last < 150) {
      requestAnimationFrame(draw);
      return;
    }
    last = ts;
    const w = mini.width, h = mini.height;
    if (w > 0 && h > 0) {
      const idata = ctx.createImageData(w, h);
      const buf32 = new Uint32Array(idata.data.buffer);
      for (let i = 0; i < buf32.length; i++) {
        const n = 6 + Math.floor(Math.random() * 37);
        buf32[i] = (255 << 24) | (n << 16) | (n << 8) | n;
      }
      ctx.putImageData(idata, 0, 0);
    }
    requestAnimationFrame(draw);
  }
  requestAnimationFrame(draw);
})();

// Waitlist form — stores email locally + opens mailto as fallback
document.getElementById('waitlist-form').addEventListener('submit', (e) => {
  e.preventDefault();
  const emailInput = document.getElementById('waitlist-email');
  const email = emailInput.value.trim();
  if (!email) return;

  // Store locally (replace with real API: Buttondown, Mailchimp, etc.)
  const existing = JSON.parse(localStorage.getItem('eyebreak_waitlist') || '[]');
  if (!existing.includes(email)) existing.push(email);
  localStorage.setItem('eyebreak_waitlist', JSON.stringify(existing));

  // Show success state
  const form = document.getElementById('waitlist-form');
  const success = document.getElementById('waitlist-success');
  form.classList.add('submitted');
  success.classList.add('show');
});

applyLang('ar');
