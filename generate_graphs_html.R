## Read UpdateExperimenten file and generate plots per cohort and experiment type based on wave
## First reads the file with the updated counts, then uses the prospectus for additional information to include
library(digest)
library("readxl")

# Read updated counts
df <- read.table('PP_UpdateExperimenten_20221103.csv', sep=";", header=FALSE, comment.char="#",
                 na.strings=".", stringsAsFactors=FALSE,
                 quote="", fill=FALSE)

# Read prospectus
prospectus <- read_excel("YOUth_prospectus_v1.4_20221101.xlsx")

# Identify relevant columns
colCohort = 2;
colWave = 3;
colSubject = 4;
colCat = 6;
colExp = 7;
colProspectus = 8;
colKeywords = 9;
colN = 11;


# Default HTML header and footer for CSS and JavaScript
htmlHead = "<html><head><title>Data Prospectus - YOUth Cohort Study - Utrecht University</title>
<script src='https://cdn.plot.ly/plotly-2.4.2.min.js'></script>
<script type='text/javascript' src='charts.js'></script>
<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css' integrity='sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm' crossorigin='anonymous'>
<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css'>
<script src='https://code.jquery.com/jquery-3.6.0.min.js' integrity='sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=' crossorigin='anonymous'></script>
<script src='https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js' integrity='sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl' crossorigin='anonymous'></script>
<link rel='stylesheet' media='all' href='https://staticweb.hum.uu.nl/youth/css/corporate.css' />
<link rel='icon' type='image/x-icon' href='../css/favicon.ico'>
<link rel='stylesheet' media='all' href='style.css' />
<div class='modal fade' id='expModal' tabindex='-1' role='dialog' aria-labelledby='exampleModalLabel' aria-hidden='true'>
  <div class='modal-dialog modal-lg' role='document'>
    <div class='modal-content'>
      <div class='modal-header'>
        <h3 class='modal-title' id='modalTitle'></h3>
        <button type='button' class='close' data-dismiss='modal' aria-label='Close'>
          <span aria-hidden='true'>&times;</span>
        </button>
      </div>
      <div class='modal-body' id='modalBody'>
      </div>
      <div class='modal-footer'>
        <button type='button' class='btn btn-primary' onclick=\"window.open('https://www.uu.nl/en/research/youth-cohort-study/data-access')\"><i class='bi bi-pencil-square'></i> Request Data</button>
        <button type='button' class='btn btn-secondary' data-dismiss='modal'>Close</button>
      </div>
    </div>
  </div>
</div>
<div class='modal fade' id='introModal' tabindex='-1' role='dialog' aria-hidden='true'>
  <div class='modal-dialog modal-lg' role='document'>
    <div class='modal-content'>
      <div class='modal-header'>
        <h2 class='modal-title' id='modalTitle'>The interactive YOUth prospectus</h2>
        <button type='button' class='close' data-dismiss='modal' aria-label='Close'>
          <span aria-hidden='true'>&times;</span>
        </button>
      </div>
      <div class='modal-body' id='modalBody'>
        <p class='intro intro-modal'>All the data collected within the YOUth Cohort Study is visualized on this page. The graphs show the number of participants per experiment (ordered by cohort and participant type, and updated periodically).</p><p class='intro intro-modal'><i class='bi bi-info-circle-fill'></i> You can click on a graph to view detailed experiment information. You can filter the prospectus by experiment name, type or by using keywords.</p>
      </div>
      <div class='modal-footer'>
        <button type='button' class='btn btn-secondary' data-dismiss='modal'>Close</button>
      </div>
    </div>
  </div>
</div>
<script>$('#introModal').modal('toggle')</script>
<div id='UU'><h1 class='page-title' style='margin-left:10px'>YOUth Cohort participants</h1></div>
<div class='nav-wrapper'><div id='navbar' class='navbar'>
  <div style='width:70%'>
  <a href='https://www.uu.nl/en/research/youth-cohort-study/' target='blank' class='nav-parent'><i class='bi bi-house-door-fill' style='margin-bottom: -1px;'></i></a>
  <a href='#cac' class='nav-parent nav-link'>Child & Adolescent:</a>
  <a class='cac nav-child nav-link' href='#cac'>Children</a>
  <a class='cap nav-child nav-link' href='#cap'>Parents</a>
  <a class='' href=''>&nbsp;</a>
  <a href='#bcc' class='nav-parent nav-link'>Baby & Child:</a>
  <a class='bcc nav-child nav-link' href='#bcc'>Children</a>
  <a class='bcm nav-child nav-link' href='#bcm'>Mothers</a>
  <a class='bcp nav-child nav-link' href='#bcp'>Partners</a>
  </div>
  <div style='width:22%'>
  <div class='input-group'>
  <input id='filterTextBox' type='text' class='form-control' aria-describedby='filter' placeholder='Filter by experiment name'>
   <button class='btn btn-outline-secondary' type='button' id='reset' style='border-radius: 0px 5px 5px 0px;' onclick='clearFilter();'>Reset</button>
  </div>
  </div>
</div>
</div>
<p class='intro' style='margin-bottom:30px'><i class='bi bi-info-circle-fill'></i> The graphs below show the number of participants per experiment (ordered by cohort and participant type). The graphs are updated periodically. </br> You can <em>click</em> on a graph to view detailed experiment information. You can <em>filter</em> by experiment name, type or using keywords.</p>

<div class='info info-hide alert alert-secondary' id='info' role='alert'><i class='bi bi-info-circle-fill'></i> Click on a graph<br />for more information  
</div>
<script>
document.getElementById('info').onclick = function() { 
  var info = document.getElementById('info');
  info.classList.add('info-hide-permanent');
};
function clearFilter() {
    document.getElementById('filterTextBox').value = '';
     $('.element').each(function() {
      a = this;  
      this.hidden = false
      }); 
}
$('#filterTextBox').on('keyup', function () {
var search = this.value;  
if( search.length < 2) { var showAll = true } else { showAll = false } 
  $('.element').each(function() {
    a = this;
    b = $(a).children('#invisible');    
    this.hidden = false; 
    if (showAll == false) {
      if (b[0].innerText.search(search) > 0 ) {this.hidden = false} else {this.hidden = true}
    }
  }); 
})
</script>"
htmlTail = "<span style='height:100px'><p></p></span><script>
window.onscroll = function() {animateNav()};
var navbar = document.getElementById('navbar');
var sticky = navbar.offsetTop;
const sections = document.querySelectorAll('section');
const navLi = document.querySelectorAll('.navbar a');

function animateNav() {
  if (window.pageYOffset >= sticky) {
    navbar.classList.add('sticky')
    info.classList.remove('info-hide')
  } else {
    navbar.classList.remove('sticky')
    info.classList.add('info-hide')
  }
  var current = '';

  sections.forEach((section) => {
    const sectionTop = section.offsetTop;
    if (pageYOffset >= sectionTop - 100) {
      current = section.getAttribute('id');
      console.log(current) }
  });

  navLi.forEach((a) => {
    a.classList.remove('active');
    if (a.classList.contains(current)) {
      a.classList.add('active');
    }
  });
} 
for(var i in document.getElementsByClassName('nav-link')) {
    var link = document.getElementsByClassName('nav-link')[i];
    link.onclick = function(e) { 
        e.preventDefault();
        navbar.classList.add('sticky')
        window.location = e.srcElement.attributes.href.textContent;     
    } 
} 
</script></body>"


# Function to create plots based on subject, cohort
YOUth_write_counts_html <- function(subject,cohort,nWaves,yMax) {
  cat("<div class='container' id='main'>")
  csvSize = dim(df)
  prospectusSize = dim(prospectus);
  vars = array();
  n = 2:csvSize[1]
  iRow = 0
  for (i in n) { ## find first wave
    if (df[i,colCohort] == cohort & df[i,colSubject] == subject) { 
      currName = df[i,colExp]
      if (is.element(currName,vars)) {
        next # skip if already included
      }
      iRow = iRow + 1
      firstMatch = 0
      vars <- append(vars,currName)
      k = 2:csvSize[1]
      for (x in k) { ## find additional waves
        if (df[x,colExp] == currName & df[x,colCohort] == cohort & df[x,colSubject] == subject) {
          if (firstMatch == 0) {
            
            # Find matching info from prospectus file
            prospectusID = df[x,colProspectus];
            p = 1:prospectusSize[1];
            for (pRow in p) {
              if (prospectus[pRow,11] == prospectusID) {
                prospectusDescr = prospectus[pRow,13]
                experimentName = prospectus[pRow,8]
                experimentType = prospectus[pRow,3]
                experimentAbout = prospectus[pRow,6]
                experimentKeywords = prospectus[pRow,9]
              }
            }
            
            # Find the first instance, then look for other waves
            firstMatch = 1
            firstWave = df[x,colWave]
            randVal = round(runif(1,1,10)*10000);
            cssTag = gsub(' ', '', experimentType, fixed = TRUE)
            experimentName = gsub("[\']", '', experimentName)
            dispName = gsub('(.{1,20})(\\s|$)', '\\1<br>', experimentName)
            addInfo = ''
            
            # find additional information on blood data
            if (experimentName == 'Blood') {
              extraInfo = strsplit(as.character(currName),':');
              dispName = paste0(dispName,' (',trimws(extraInfo[[1]][2]),')');
              addInfo = trimws(extraInfo[[1]][2])
            }
            
            # Print HTML and JavaScript for the plots
            cat(paste0("<div class='element'><div class='invisible' id='invisible'> ",tolower(experimentName)," ",tolower(cssTag)," ",tolower(df[i,colProspectus])," ",tolower(addInfo)," ",tolower(experimentKeywords),"</div><div id='",digest::digest(currName),randVal,"' class='plot'></div>\n"))
            cat(paste0("<script>create_plot_",nWaves,"(",iRow,",",yMax,",'",digest::digest(currName),randVal,"','",dispName,"'")) 
            
            ## add zeros for preceding waves if measurement is included at a later wave
            if (cohort == 'B&K' & subject == 'Kinderen') {
              if (firstWave == '10m') {
                cat(",0,'5m'")
              } else if (firstWave == '3y') {
                cat(",0,'5m',0,'10m'")
              }
            } else if (cohort == 'B&K' & subject != 'Kinderen') {
              if (firstWave == '30w') {
                cat(",0,'20w'")
              } else if (firstWave == '5m') {
                cat(",0,'20w',0,'30w'")
              } else if (firstWave == '10m') {
                cat(",0,'20w',0,'30w',0,'5m'")
              } else if (firstWave == '3y') {
                cat(",0,'20w',0,'30w',0,'5m',0,'10m'")
              }
            } else if (cohort == 'K&T' & firstWave == '12y') {
                cat(",0,'9y'")
            }
              
            cat(paste0(",",df[x,colN],",'",df[x,colWave],"'"))
          } else {
            cat(paste0(",",df[x,colN],",'",df[x,colWave],"'"))
          }
        }
      }
      cat(paste0(")</script>\n"))
      prospectusDescr = gsub("[\r\n]", "", prospectusDescr)
      prospectusDescr = gsub("['â€™Ã\"‘’]", '', prospectusDescr)
      prospectusDescr = gsub("–", ' to ', prospectusDescr)
      prospectusDescr = gsub("μ", ' micro ', prospectusDescr)
      
      # Print HTML and JavaScript for the modal window with additional prospectus information
      cat(paste0("<script>document.getElementById('",digest::digest(currName),randVal,"').onclick = function() { create_modal('",experimentName,"','",prospectusDescr,"','",toupper(experimentType),"','",df[i,colProspectus],"','",toupper(experimentAbout),"')};</script>\n"))
     
      cat(paste0("<div class='tagline ",tolower(cssTag),"'>",experimentType,"</div></div>"))

      if (iRow > 6) {
        cat(paste0("</div><div class='container' id='main'>\n"))
        iRow = 0
      }
    }
  }
  cat("</div></section>\n")
}

# Print plots for each category, separated by section headers
outputFile = paste0('prospectus.html')
sink(outputFile)
cat(htmlHead)
cat('<a class="anchor" id="cac"></a><section id="cac"><div class="container" id="main"><div><h2>Child & Adolescent: Children</h2></div>')
cat('<div><table><tr><td class="w1">Around 9y (concluded)</td><td class="w2">Around 12y (ongoing)</td></tr></table></div></div>')
subject = "Kinderen"
cohort = "K&T"
YOUth_write_counts_html(subject,cohort,2,1500)

cat('<a class="anchor" id="cap"></a><section id="cap"><div class="container" id="main"><div><h2>Child & Adolescent: Parents</h2></div>')
cat('<div><table><tr><td class="w1">Around 9y (concluded)</td><td class="w2">Around 12y (ongoing)</td></tr></table></div></div>')
subject = "Ouders"
cohort = "K&T"
YOUth_write_counts_html(subject,cohort,2,1500)
subject = "Moeders"
cohort = "K&T"
YOUth_write_counts_html(subject,cohort,2,1500)
subject = "Vaders"
cohort = "K&T"
YOUth_write_counts_html(subject,cohort,2,1500)

cat('<a class="anchor" id="bcc"></a><section id="bcc"><div class="container" id="main"><div><h2>Baby & Children: Children</h2></div>')
cat('<div><table><tr><td class="w1">5m</td><td class="w2">10m</td><td class="w3">Around 3y</td></tr></table></div></div>')
subject = "Kinderen"
cohort = "B&K"
YOUth_write_counts_html(subject,cohort,3,1800)

cat('<a class="anchor" id="bcm"></a><section id="bcm"><div class="container" id="main"><div><h2>Baby & Children: Mothers</h2></div>')
cat('<div><table><tr><td class="w1">20w</td><td class="w2">30w</td><td class="w3">5m</td><td class="w4">10m</td><td class="w5">Around 3y</td></tr></table></div></div>')
subject = "Moeders"
cohort = "B&K"
YOUth_write_counts_html(subject,cohort,5,2500)

cat('<a class="anchor" id="bcp"></a><section id="bcp"><div class="container" id="main"><div><h2>Baby & Children: Partners</h2></div>')
cat('<div><table><tr><td class="w1">20w</td><td class="w2">30w</td><td class="w3">5m</td><td class="w4">10m</td><td class="w5">Around 3y</td></tr></table></div></div>')
subject = "Partners"
cohort = "B&K"
YOUth_write_counts_html(subject,cohort,5,1800)

cat(htmlTail)
closeAllConnections() 




