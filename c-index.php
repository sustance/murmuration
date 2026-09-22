<h1>Murmur</h1>
<?php
// HSF - Hard Science Fiction Hub
// hsf.identity2.com
// Email forms only at launch - PlanetScale DB integration planned
// All large assets linked from sustance.github.io

$site_email = 'identity2hsf@enve.net';
$site_name  = 'HSF — Hard Science Fiction Hub';
$github_cdn = 'https://sustance.github.io/hsf-assets';

// Simple form handler - sends to email via mailto redirect
// Production: replace with PHP mail() or SMTP when server mail is configured
function form_submitted($key) {
    return isset($_POST[$key]) && !empty(trim($_POST[$key]));
}

$form_action = $_SERVER['PHP_SELF'];
$submitted_form = isset($_POST['form_type']) ? $_POST['form_type'] : '';

// Quiz data
$quiz_questions = [
    ["q" => "What is the Oberth effect?",
     "a" => ["A fictional FTL drive concept", "Efficiency gained by firing engines at orbital periapsis", "Gravity slingshot around a gas giant", "Solar wind drag on deep space probes"],
     "correct" => 1],
    ["q" => "In a realistic generation ship, what is the primary unsolved biological problem?",
     "a" => ["Fuel for 1000 years", "Genetic diversity and population bottlenecks", "Ship structural fatigue", "Navigation without GPS"],
     "correct" => 1],
    ["q" => "Why is cryogenic propellant storage in direct sunlight a serious engineering problem?",
     "a" => ["Solar radiation degrades fuel chemistry", "Boil-off losses require constant active cooling consuming mission energy", "Sunlight causes tank corrosion", "It interferes with navigation sensors"],
     "correct" => 1],
    ["q" => "What does 'mass ratio' refer to in rocketry?",
     "a" => ["Ratio of payload to fairing weight", "Ratio of fueled mass to dry mass — drives the Tsiolkovsky equation", "Center of mass balance for launch", "Ratio of thrust to atmospheric pressure"],
     "correct" => 1],
    ["q" => "Which author is most associated with founding hard SF as a distinct genre identity?",
     "a" => ["H.G. Wells", "Isaac Asimov", "Hal Clement", "Arthur C. Clarke"],
     "correct" => 2],
];

$quiz_score = null;
if ($submitted_form === 'quiz') {
    $quiz_score = 0;
    foreach ($quiz_questions as $i => $q) {
        if (isset($_POST["q$i"]) && intval($_POST["q$i"]) === $q['correct']) {
            $quiz_score++;
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO: Hard sci-fi keywords -->
<title>HSF — Hard Science Fiction Hub | Where Real Science Becomes Fiction</title>
<meta name="description" content="The home for hard science fiction readers and writers. Hard sci-fi, hard SF, scientifically accurate science fiction, AI-written sci-fi, rigorous speculative fiction. No fantasy. Free book links, community, and more.">
<meta name="keywords" content="hard sci-fi, hard science fiction, hard SF, rigorous sci-fi, scientifically accurate sci-fi, physics-based sci-fi, hard sci-fi recommendations, best hard sci-fi novels, hard sci-fi like The Martian, hard sci-fi like Alastair Reynolds, hard sci-fi like Kim Stanley Robinson, hard sci-fi authors, new hard sci-fi 2025, hard sci-fi hidden gems, sci-fi without fantasy, realistic sci-fi, sci-fi for engineers, sci-fi for physicists, interplanetary hard sci-fi, orbital mechanics sci-fi, near future hard sci-fi, hard sci-fi community, AI written hard sci-fi, AI science fiction, speculative engineering fiction, science news turned into fiction, hard sci-fi is dead, where to find hard sci-fi">
<meta name="robots" content="index, follow">
<meta property="og:title" content="HSF — Hard Science Fiction Hub">
<meta property="og:description" content="The only hub dedicated exclusively to hard sci-fi. Agnostic about how it's written. No fantasy. Real physics.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://hsf.identity2.com">

<!-- Fonts from Google — lightweight, distinctive pairing -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&family=Exo+2:ital,wght@0,300;0,600;0,800;1,300&display=swap" rel="stylesheet">

<link rel="stylesheet" href="https://sustance.github.io/hsf-assets/style.css">

</head>
<body>

<!-- ================================================================
     HEADER
     ================================================================ -->
<header>
<div class="container">
<div class="header-grid">
<div>

    <h1>HSF <span style="font-weight:300;font-size:0.55em;color:var(--text-dim)">Hub</span><br>
    <span style="color:var(--amber)">Hard Science Fiction</span><br>
    </h1>
    <p class="tagline">Where real science headlines become tomorrow's stories. <br>
    No fantasy. No apologies. No gatekeeping on method.</p>
</div>
<div class="header-svg-wrap">
    <image src="https://sustance.github.io/hsf-assets/orbital.svg" width="160" height="160" alt=""/> 






    
</div>
</div>
</div>
</header>

<!-- ================================================================
     NAV
     ================================================================ 
     -->
<nav>
<div class="container">
<ul>
  <li><a href="#manifesto">Manifesto</a></li>
  <li><a href="#books">Books</a></li>
  <!--<li><a href="#quiz">SF Quiz</a></li>-->
  <li><a href="#review">Review</a></li>
  <li><a href="#submit-book">Submit</a></li>
  <li><a href="#host">Host My Book</a></li>
  <li><a href="#wants">Want List</a></li>
  <li><a href="#ama">Author AMA</a></li>
  <li><a href="#about">About</a></li>
</ul>
</div>
</nav>

<!-- ================================================================
     MANIFESTO
     ================================================================ -->
<section id="manifesto">
<div class="container">

<h2>Where Real Science Becomes Fiction</h2>

<div class="pull-quote">
You read the headline: <em>"Fuel depots in orbit for interplanetary travel."</em><br>
Your brain immediately asks — wait, cryogenic propellant in direct sunlight?<br>
How do you keep it cold? What orbit keeps it permanently shaded?<br>
What does the engineering actually look like?<br><br>
That's not a problem. That's a story.
</div>

<p>This site exists for people whose minds work that way. Classic <strong class="amber">hard sci-fi</strong> readers who devoured Clarke, Niven, Benford, Baxter, and Stross — and who find today's fiction landscape flooded with fantasy while genuine <strong>speculative engineering fiction</strong> is nearly impossible to locate.</p>

<div class="two-col mt2">
<div class="card">
<h3>// What We Are</h3>
<p class="mt1">A curated hub and directory for hard science fiction grounded in real science. We link free and paid non-fantasy SF wherever it lives online. We are completely <span class="amber">agnostic about how it's written</span> — human, AI-assisted, or fully AI-generated. If the physics is honest and the speculation is rigorous, it belongs here.</p>
</div>
<div class="card card-teal">
<h3>// What We Are Not</h3>
<p class="mt1">We are not a fantasy site. We are not a general fiction aggregator. We do not care about method — only rigour. We do not gatekeep on authorship. We do not take money to list books. If it's <span class="teal">hard SF, it's welcome</span>.</p>
</div>
</div>

<div class="card mt2" style="border-left-color:var(--teal)">
<h3>// Got a story?</h3>
<p class="mt1">Free or paid — if it's non-fantasy science fiction with real scientific backbone, <a href="#submit-book" class="amber">submit it</a> and we'll link it. No charge. No gatekeeping on method. The science is happening. The stories should match it.</p>
</div>

   <image href="https://sustance.github.io/hsf-assets/divider-wave.svg" width="900" height="30"/>

</div>
</section>

<!-- ================================================================
     BOOK LISTINGS (placeholder)
     ================================================================ -->
<section id="books">
<div class="container">
<h2>Hard SF Directory</h2>
<p class="dim mono mt1"><?php echo date('Y-m-d'); ?> — <?php echo rand(3,7); ?> listings at launch. Submit yours below.</p>

<hr class="rule">

<!-- Sample placeholder listings — replace with DB query when PlanetScale is live -->
<?php
$placeholder_books = [
    ["num"=>"001","title"=>"The Martian","author"=>"Andy Weir","tag"=>"FREE SAMPLE","url"=>"#","note"=>"The archetypal modern hard SF survival story."],
    ["num"=>"002","title"=>"A Fire Upon the Deep","author"=>"Vernor Vinge","tag"=>"PAID","url"=>"#","note"=>"Zones of thought — hard SF space opera at its most rigorous."],
    ["num"=>"003","title"=>"Dragon's Egg","author"=>"Robert Forward","tag"=>"PAID","url"=>"#","note"=>"Life on a neutron star — physics as plot."],
];
foreach ($placeholder_books as $b):
?>
<div class="book-item">
  <span class="book-num"><?php echo $b['num']; ?></span>
  <div>
    <strong><?php echo htmlspecialchars($b['title']); ?></strong>
    <div class="book-meta"><?php echo htmlspecialchars($b['author']); ?> — <?php echo htmlspecialchars($b['note']); ?></div>
  </div>
  <span class="book-tag"><?php echo $b['tag']; ?></span>
</div>
<?php endforeach; ?>

<p class="dim mono mt2" style="font-size:0.8rem;">/* TODO: replace static array with PDO query to PlanetScale once DB credentials configured */<br>
/* submit your book below — approved listings appear here */</p>


<!-- SVG: constellation decoration -->
 <image src="https://sustance.github.io/hsf-assets/constellation.svg" width="400" height="60"/>

</div>
</section>



<!-- ================================================================
     REVIEW A BOOK
     ================================================================ -->
<section id="review">
<div class="container">
<h2>Review a Book</h2>
<p class="mt1">Read something in the directory? Leave a review. Reviews are held for moderation before appearing.</p>
<p class="mono" style="font-size:0.75rem;color:var(--text-dim);margin-top:0.5rem;">/* TODO: store to PlanetScale reviews table — email queue at launch */</p>

<?php if ($submitted_form === 'review'): ?>
<div class="success-msg">// REVIEW RECEIVED — queued for moderation. Thank you.</div>
<?php endif; ?>

<div class="form-wrap">
<form method="POST" action="<?php echo htmlspecialchars("mailto:$site_email"); ?>" enctype="text/plain">
<input type="hidden" name="form_type" value="review">
<div class="two-col">
  <div class="form-group">
    <label for="r_name">Your Name / Handle</label>
    <input type="text" id="r_name" name="reviewer_name" placeholder="e.g. DeltaV_Reader" required>
  </div>
  <div class="form-group">
    <label for="r_email">Email (not published)</label>
    <input type="email" id="r_email" name="reviewer_email" placeholder="you@example.com">
  </div>
</div>
<div class="form-group">
  <label for="r_book">Book Title</label>
  <input type="text" id="r_book" name="book_title" placeholder="Title of the book you're reviewing" required>
</div>
<div class="form-group">
  <label for="r_rating">Rating</label>
  <select id="r_rating" name="rating">
    <option value="5">5 — Mandatory reading for any hard SF fan</option>
    <option value="4">4 — Solid hard SF, recommended</option>
    <option value="3">3 — Decent, some handwaving</option>
    <option value="2">2 — Weak on the science</option>
    <option value="1">1 — Misleadingly labelled as hard SF</option>
  </select>
</div>
<div class="form-group">
  <label for="r_text">Review</label>
  <textarea id="r_text" name="review_text" placeholder="Your review — what works, what doesn't, how hard is the science?" required></textarea>
</div>
<button type="submit" class="btn">// SUBMIT REVIEW</button>
<span class="php-comment" style="margin-left:1rem;">/* held for approval */</span>
</form>
</div>
</div>
</section>

<!-- ================================================================
     SUBMIT A BOOK LINK
     ================================================================ -->
<section id="submit-book">
<div class="container">

<h2>Submit a Book Link</h2>
<p class="mt1">Found hard SF online that deserves to be listed here? Submit it. Free or paid. Human or AI-written. We list it if the physics is honest.</p>

<?php if ($submitted_form === 'submit_book'): ?>
<div class="success-msg">// SUBMISSION RECEIVED — we'll review and list it. Thank you.</div>
<?php endif; ?>

<div class="form-wrap">
<form method="POST" action="<?php echo htmlspecialchars("mailto:$site_email"); ?>" enctype="text/plain">
<input type="hidden" name="form_type" value="submit_book">
<div class="two-col">
  <div class="form-group">
    <label for="sb_title">Book Title</label>
    <input type="text" id="sb_title" name="book_title" placeholder="Full title" required>
  </div>
  <div class="form-group">
    <label for="sb_author">Author / Handle</label>
    <input type="text" id="sb_author" name="author" placeholder="Author name or pen name" required>
  </div>
</div>
<div class="form-group">
  <label for="sb_url">Link / URL</label>
  <input type="url" id="sb_url" name="book_url" placeholder="https://" required>
</div>
<div class="two-col">
  <div class="form-group">
    <label for="sb_type">Free or Paid?</label>
    <select id="sb_type" name="access_type">
      <option value="free">Free to read online</option>
      <option value="paid">Paid</option>
      <option value="mixed">Free sample + paid full</option>
    </select>
  </div>
  <div class="form-group">
    <label for="sb_written">Written by?</label>
    <select id="sb_written" name="authorship">
      <option value="human">Human authored</option>
      <option value="ai_assisted">Human + AI assisted</option>
      <option value="ai">AI generated</option>
      <option value="unknown">Unknown / not stated</option>
    </select>
  </div>
</div>
<div class="form-group">
  <label for="sb_desc">Brief Description (1-3 sentences)</label>
  <textarea id="sb_desc" name="description" placeholder="What's it about? Why is it hard SF? What's the core science?" style="min-height:70px;" required></textarea>
</div>
<div class="form-group">
  <label for="sb_contact">Your Email (optional — for follow-up)</label>
  <input type="email" id="sb_contact" name="contact_email" placeholder="you@example.com">
</div>
<button type="submit" class="btn">// SUBMIT LINK</button>
</form>
</div>
</div>
</section>

<!-- ================================================================
     HOST MY BOOK
     ================================================================ -->
<section id="host">
<div class="container">

<h2>Host My Book</h2>
<p class="mt1">Can't find a free host that accepts your hard SF — especially if it's AI-assisted? We'll host it here for free. No conditions except: it must be genuine hard SF.</p>

<?php if ($submitted_form === 'host_book'): ?>
<div class="success-msg">// REQUEST RECEIVED — we'll be in touch about hosting your work.</div>
<?php endif; ?>

<div class="form-wrap">
<form method="POST" action="<?php echo htmlspecialchars("mailto:$site_email"); ?>" enctype="text/plain">
<input type="hidden" name="form_type" value="host_book">
<div class="two-col">
  <div class="form-group">
    <label for="h_name">Author Name / Handle</label>
    <input type="text" id="h_name" name="author_name" placeholder="Name or pen name" required>
  </div>
  <div class="form-group">
    <label for="h_email">Contact Email</label>
    <input type="email" id="h_email" name="contact_email" placeholder="you@example.com" required>
  </div>
</div>
<div class="form-group">
  <label for="h_title">Book / Story Title</label>
  <input type="text" id="h_title" name="book_title" placeholder="Title" required>
</div>
<div class="two-col">
  <div class="form-group">
    <label for="h_wc">Approximate Word Count</label>
    <input type="text" id="h_wc" name="word_count" placeholder="e.g. 80,000">
  </div>
  <div class="form-group">
    <label for="h_auth">Authorship</label>
    <select id="h_auth" name="authorship">
      <option value="human">Human authored</option>
      <option value="ai_assisted">Human + AI assisted</option>
      <option value="ai">AI generated</option>
    </select>
  </div>
</div>
<div class="form-group">
  <label for="h_pitch">Pitch (2-5 sentences)</label>
  <textarea id="h_pitch" name="pitch" placeholder="Tell us what your book is about and why the science is solid." required></textarea>
</div>
<div class="form-group">
  <label for="h_why">Why Can't You Self-Host? (optional)</label>
  <input type="text" id="h_why" name="hosting_issue" placeholder="e.g. Platform bans AI content, no technical skills, etc.">
</div>
<button type="submit" class="btn">// REQUEST HOSTING</button>
</form>
</div>
</div>
</section>

<!-- ================================================================
     READER WANTS LIST
     ================================================================ -->
<section id="wants">
<div class="container">

<h2>Reader Wants List</h2>
<p class="mt1">Tell us what hard SF story you want to exist. Authors browse this for inspiration. Be specific — the more science, the better.</p>

<?php if ($submitted_form === 'wants'): ?>
<div class="success-msg">// WANT LOGGED — authors are watching this list.</div>
<?php endif; ?>

<!-- SVG: brain/signal decoration placeholder -->
<image src="https://sustance.github.io/hsf-assets/signal-bar.svg">


<div class="form-wrap">
<form method="POST" action="<?php echo htmlspecialchars("mailto:$site_email"); ?>" enctype="text/plain">
<input type="hidden" name="form_type" value="wants">
<div class="form-group">
  <label for="w_name">Your Handle (optional)</label>
  <input type="text" id="w_name" name="reader_handle" placeholder="Anonymous is fine">
</div>
<div class="form-group">
  <label for="w_want">The Story You Want to Exist</label>
  <textarea id="w_want" name="want_description" placeholder="e.g. A hard SF story about cryogenic fuel depot management in a permanently shaded Lagrange orbit — the crew, the engineering failures, the political fight over who owns the fuel..." required></textarea>
</div>
<div class="form-group">
  <label for="w_science">Core Science Involved</label>
  <input type="text" id="w_science" name="core_science" placeholder="e.g. orbital mechanics, cryogenics, thermodynamics">
</div>
<button type="submit" class="btn btn-teal">// ADD TO WANTS LIST</button>
</form>
</div>

<p class="php-comment mt2">/* TODO: display approved wants as a public browsable list — DB backend pending */</p>
</div>
</section>

<!-- ================================================================
     AUTHOR AMA
     ================================================================ -->
<section id="ama">
<div class="container">

<h2>Author Q&amp;A / AMA</h2>
<p class="mt1">Questions for authors listed in the directory, or for the site itself. Moderated. Authors are not obligated to respond but many will.</p>

<?php if ($submitted_form === 'ama'): ?>
<div class="success-msg">// QUESTION RECEIVED — forwarded to the relevant author or site admin.</div>
<?php endif; ?>

<div class="form-wrap">
<form method="POST" action="<?php echo htmlspecialchars("mailto:$site_email"); ?>" enctype="text/plain">
<input type="hidden" name="form_type" value="ama">
<div class="two-col">
  <div class="form-group">
    <label for="ama_name">Your Name / Handle</label>
    <input type="text" id="ama_name" name="questioner_name" placeholder="Handle">
  </div>
  <div class="form-group">
    <label for="ama_directed">Directed To</label>
    <input type="text" id="ama_directed" name="directed_to" placeholder="Author name or 'HSF Site'">
  </div>
</div>
<div class="form-group">
  <label for="ama_q">Your Question</label>
  <textarea id="ama_q" name="question" placeholder="Ask anything — process, science, inspiration, AI use, publishing, worldbuilding..." required></textarea>
</div>
<div class="form-group">
  <label for="ama_email">Your Email (optional — for follow-up)</label>
  <input type="email" id="ama_email" name="email" placeholder="you@example.com">
</div>
<button type="submit" class="btn">// SUBMIT QUESTION</button>
</form>
</div>
</div>
</section>

<!-- ================================================================
     ABOUT
     ================================================================ -->
<section id="about">
<div class="container">

<h2>About HSF</h2>

<div class="two-col">
<div>
<p>This site is built by a lifelong hard science fiction reader who got tired of searching. The genre is rare. The existing platforms mix it invisibly with fantasy, or ban AI-assisted writing outright, making genuinely interesting new work unfindable.</p>
<p class="mt1">HSF exists as a neutral, stable, independently hosted directory and community hub. It will never take advertising money to list books. It will never ban work based on authorship method. It will always link freely to work hosted elsewhere.</p>
</div>
<div>
<div class="card card-teal">
<h3>// Tech Stack</h3>
<p class="mt1 mono" style="font-size:0.8rem;">
  Host: various/moves (sometines slow)<br>
  Domain: hsf.identity2.com<br>
  DB: turso.tech<br>
  Forms: email queue at launch<br>
  Lang: PHP — minimal dependencies
</p>
</div>
</div>
</div>

<!-- SVG: tech grid decoration placeholder -->
<svg class="svg-deco mt2" viewBox="0 0 800 50" width="100%" height="50" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
  <!-- TODO: <image href="https://sustance.github.io/hsf-assets/grid-deco.svg" width="800" height="50"/> -->
  <?php for($x=0;$x<=800;$x+=50): ?>
  <line x1="<?php echo $x; ?>" y1="0" x2="<?php echo $x; ?>" y2="50" stroke="#1e3040" stroke-width="0.5"/>
  <?php endfor; ?>
  <?php for($y=0;$y<=50;$y+=10): ?>
  <line x1="0" y1="<?php echo $y; ?>" x2="800" y2="<?php echo $y; ?>" stroke="#1e3040" stroke-width="0.5"/>
  <?php endfor; ?>
  <rect x="350" y="15" width="100" height="20" fill="none" stroke="#e8a020" stroke-width="1" opacity="0.4"/>
  <text x="400" y="29" text-anchor="middle" font-family="'Share Tech Mono',monospace" font-size="8" fill="#e8a020" opacity="0.7">HSF // GRID</text>
</svg>

<div class="card mt2">
<p class="mono" style="font-size:0.8rem;color:var(--text-dim)">
/* Keywords indexed on this page for search discovery: */<br>
/* hard sci-fi · hard science fiction · hard SF · rigorous sci-fi · scientifically accurate sci-fi */<br>
/* physics-based sci-fi · hard sci-fi recommendations · best hard sci-fi novels · hard sci-fi 2025 */<br>
/* sci-fi without fantasy · sci-fi for engineers · orbital mechanics sci-fi · AI written hard sci-fi */<br>
/* speculative engineering fiction · science news to fiction · hard sci-fi community · hard SF hub */
</p>
</div>
</div>
</section>

<!-- ================================================================
     FOOTER
     ================================================================ -->
<footer>
<div class="container">
<div class="footer-grid">
<div>
  <span class="amber" style="font-size:0.9rem;font-weight:600;">HSF — Hard Science Fiction Hub</span><br>
  hsf.identity2.com &nbsp;|&nbsp; <?php echo date('Y'); ?> &nbsp;|&nbsp;
  contact: <a href="mailto:<?php echo $site_email; ?>" style="color:var(--teal);text-decoration:none;"><?php echo $site_email; ?></a><br>
  <span style="color:var(--text-dim)">No ads. No gatekeeping. No fantasy. Agnostic on authorship.</span>
</div>
<div style="text-align:right;">
  <span class="blink" style="color:var(--amber);">●</span> <span style="color:var(--text-dim)">ONLINE</span><br>
  <span style="color:var(--border)">v0.1.0-launch</span>
</div>
</div>
<div style="margin-top:1rem;color:var(--border);font-size:0.65rem;">
  /* PHP — lightweight — minimal dependencies — cron deployed from github — assets from sustance.github.io */
</div>
</div>
</footer>

</body>
</html>
