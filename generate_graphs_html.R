## Read UpdateExperimenten file and generate plots per cohort and experiment type based on wave
## First reads the file with the updated counts, then uses the prospectus for additional information to include
library(digest)
library("readxl")

# Read updated counts
df <- read.table('UpdateExperimenten.csv', sep=";", header=FALSE, comment.char="#",
                        na.strings=".", stringsAsFactors=FALSE,
                      quote="", fill=FALSE)
# Read prospectus
prospectus <- read_excel("prospectus_v1.31.xlsx")

# Identify relevant columns
colCohort = 2;
colWave = 3;
colSubject = 4;
colCat = 6;
colExp = 7;
colProspectus = 8;
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
</head><body>
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
        <button type='button' class='btn btn-primary' onclick=\"window.open('https://www.uu.nl/en/research/youth-cohort-study/data-access')\"><i class=\"bi bi-pencil-square\"></i> Request Data</button>
        <button type='button' class='btn btn-secondary' data-dismiss='modal'>Close</button>
      </div>
    </div>
  </div>
</div>
<p class='intro' style='margin-bottom:30px'>The graphs below show the <strong>number of participants per experiment</strong> (ordered by cohort and participant type).<br /> 
<strong>Click on a graph</strong> to see a detailed description. The graphs are updated periodically.</p>
<div id='UU'><h1 class='page-title' style='margin-left:10px'>YOUth Cohort participants</h1></div>
<div class='nav-wrapper'><div id='navbar' class='navbar'>
  <a href='https://www.uu.nl/en/research/youth-cohort-study/' target='blank' class='nav-parent'><i class=\"bi bi-house-door-fill\"></i></a>
  <a href='#cac' class='nav-parent nav-link'>Child & Adolescent:</a>
  <a class='cac nav-child nav-link' href='#cac'>Children</a>
  <a class='cap nav-child nav-link' href='#cap'>Parents</a>
  <a class='' href=''>&nbsp;</a>
  <a href='#bcc' class='nav-parent nav-link'>Baby & Child:</a>
  <a class='bcc nav-child nav-link' href='#bcc'>Children</a>
  <a class='bcm nav-child nav-link' href='#bcm'>Mothers</a>
  <a class='bcp nav-child nav-link' href='#bcp'>Partners</a>
  <div class='info info-hide' id='info'><i class='bi bi-info-circle-fill'></i> Click on a graph for more information</div>
</div></div>
<div style='width:560px;margin:15px'>
  <div class='input-group input-group-lg'>
  <span class='input-group-text'><i class='bi bi-funnel-fill'></i></span>
  <input id='filterTextBox' type='text' class='form-control' aria-describedby='filter' placeholder='Filter'>
  </div>
</div>
<script>
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
              if (prospectus[pRow,10] == prospectusID) {
                prospectusDescr = prospectus[pRow,12]
                experimentName = prospectus[pRow,8]
                experimentType = prospectus[pRow,3]
                experimentAbout = prospectus[pRow,6]
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
              extraInfo = strsplit(currName,':');
              dispName = paste0(dispName,' (',trimws(extraInfo[[1]][2]),')');
              addInfo = trimws(extraInfo[[1]][2])
            }
            
            # Print HTML and JavaScript for the plots
            cat(paste0("<div class='element'><div class='invisible' id='invisible'> ",tolower(experimentName)," ",tolower(cssTag)," ",tolower(df[i,colProspectus])," ",tolower(addInfo)," </div><div id='",digest::digest(currName),randVal,"' class='plot'></div>\n"))
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


## Read UpdateExperimenten file and generate plots per cohort and experiment type based on wave
library(digest)
df <- read.table('ExperimentUpdate.csv', sep=";", header=FALSE, comment.char="#",
                        na.strings=".", stringsAsFactors=FALSE,
                        quote="", fill=FALSE)

# default HTML header and footer
htmlHead = "<html><head>
<script src='https://cdn.plot.ly/plotly-2.4.2.min.js'></script>
<script>function create_plot_2(e,a,t,r,i,o,l,n){1==e?(showTicks=!0,marginLeft=80):(showTicks=!1,marginLeft=30),trace1.y=[i],trace2.y=[l],trace1.name=o,trace2.name=n;var s=[trace1,trace2],c={plot_bgcolor:'#f6f6f6',paper_bgcolor:'#f6f6f6',margin:{l:marginLeft,r:marginRight,b:marginBottom,t:marginTop,pad:4},showlegend:!1,title:r,barmode:'grouped',hoverlabel:{font:{size:16}},font:{size:titleSize,family:'Helvetica, sans-serif'},xaxis:{fixedrange:!0,showticklabels:!1},yaxis:{title:'',titlefont:{family:'Helvetica, sans-serif',size:12,color:'grey'},range:[0,a],fixedrange:!0,showgrid:!0,zeroline:!0,showline:!1,zerolinewidth:2,zerolinecolor:'#42414C',showticklabels:showTicks,tickfont:{size:12,family:'Helvetica, sans-serif'}},legend:{font:{size:12,family:'Helvetica, sans-serif'}}};Plotly.newPlot(t,s,c)}function create_plot_3(e,a,t,r,i,o,l,n,s,c){1==e?(showTicks=!0,marginLeft=80):(showTicks=!1,marginLeft=30),trace1.y=[i],trace2.y=[l],trace3.y=[s],trace1.name=o,trace2.name=n,trace3.name=c;var f=[trace1,trace2,trace3],m={plot_bgcolor:'#f6f6f6',paper_bgcolor:'#f6f6f6',margin:{l:marginLeft,r:marginRight,b:marginBottom,t:marginTop,pad:4},showlegend:!1,title:r,barmode:'grouped',hoverlabel:{font:{size:16}},font:{size:titleSize,family:'Helvetica, sans-serif'},xaxis:{fixedrange:!0,showticklabels:!1},yaxis:{title:'',titlefont:{family:'Helvetica, sans-serif',size:12,color:'grey'},range:[0,a],fixedrange:!0,showgrid:!0,zeroline:!0,showline:!1,zerolinewidth:2,zerolinecolor:'#42414C',showticklabels:showTicks,tickfont:{size:12,family:'Helvetica, sans-serif'}},legend:{font:{size:12,family:'Helvetica, sans-serif'}}};Plotly.newPlot(t,f,m)}function create_plot_5(e,a,t,r,i,o,l,n,s,c,f,m,g,y){1==e?(showTicks=!0,marginLeft=80):(showTicks=!1,marginLeft=30),trace1.y=[i],trace2.y=[l],trace3.y=[s],trace4.y=[f],trace5.y=[g],trace1.name=o,trace2.name=n,trace3.name=c,trace4.name=m,trace5.name=y;var h=[trace1,trace2,trace3,trace4,trace5],p={plot_bgcolor:'#f6f6f6',paper_bgcolor:'#f6f6f6',margin:{l:marginLeft,r:marginRight,b:marginBottom,t:marginTop,pad:4},showlegend:!1,title:r,barmode:'grouped',hoverlabel:{font:{size:16}},font:{size:titleSize,family:'Helvetica, sans-serif'},xaxis:{showticklabels:!1,fixedrange:!0},yaxis:{title:'',titlefont:{family:'Helvetica, sans-serif',size:12,color:'grey'},range:[0,a],fixedrange:!0,showgrid:!0,zeroline:!0,showline:!1,zerolinewidth:2,zerolinecolor:'#42414C',showticklabels:showTicks,tickfont:{size:12,family:'Helvetica, sans-serif'}},legend:{font:{size:12,family:'Helvetica, sans-serif'}}};Plotly.newPlot(t,h,p)}titleSize=12,marginRight=10,marginBottom=100,marginTop=60,waveColors=['#E43038','#ED7539','#FABD6B','#FDC61A','#FFE10C'],trace1={name:'Wave 1',type:'bar',marker:{color:waveColors[0],opacity:.9},hovertemplate:'%{y}'},trace2={name:'Wave 2',type:'bar',marker:{color:waveColors[1],opacity:.9},hovertemplate:'%{y}'},trace3={name:'Wave 3',type:'bar',marker:{color:waveColors[2],opacity:.9},hovertemplate:'%{y}'},trace4={name:'Wave 4',type:'bar',marker:{color:waveColors[3],opacity:.9},hovertemplate:'%{y}'},trace5={name:'Wave 5',type:'bar',marker:{color:waveColors[4],opacity:.9},hovertemplate:'%{y}'};</script>
<link rel='stylesheet' media='all' href='https://staticweb.hum.uu.nl/youth/css/corporate.css' />
<style>
#navbar{overflow:hidden;background-color:#000;z-index:10;margin-left:-10px;width:1410px}#navbar a{float:left;display:block;padding:20px;text-decoration:none;font-size:24;color:#fff}.nav-parent{font-weight:800}.nav-child{text-align:left;margin-left:-20px!important}.content{padding:0}.sticky{position:fixed;top:0;width:100%}.sticky+.content{padding-top:80px}.active{color:#999!important;font-weight:200}.modebar{display:none!important}.container{display:flex;width:1400px}.plot{margin-left:-30px;width:220px}hr{margin-top:20px;margin-bottom:20px;border:0;border-top:1px solid #aaa}body{font-family:Helvetica,Arial,sans-serif}p{font-weight:200;margin-top:1.75em;margin-bottom:1.75em;margin-left:1.75em} #UU{overflow:hidden;background-color:#FECB35;z-index:10;margin-left:-10px;width:1410px;} #UU h1{float:left;display:block;padding:15px;text-decoration:none;font-size:30;color:#000;margin-top:10px;margin-bottom: 10px;margin-left: 0px}h2{margin-left: 10px; margin-bottom:30px}</style>
</head><body>
<p class='intro' style='margin-bottom:30px'>The graphs below show the amount of data collected per experiment (ordered by cohort and subject type). If you hover over the graph, you will see the exact numbers. The graphs will be updated periodically.</p>
<div id='UU'><h1 class='page-title' style='margin-left:10px'>YOUth Cohort participants</h1></div>
<div id='navbar' class='navbar'>
  <a href='#cac' class='nav-parent'>Child & Adolescent:</a>
  <a class='cac nav-child' href='#cac'>Children</a>
  <a class='cap nav-child' href='#cap'>Parents</a>
  <a class='' href=''>&nbsp;</a>
  <a href='#bcc' class='nav-parent'>Baby & Child:</a>
  <a class='bcc nav-child' href='#bcc'>Children</a>
  <a class='bcm nav-child' href='#bcm'>Mothers</a>
  <a class='bcp nav-child' href='#bcp'>Partners</a>
</div>"
htmlTail = "<span style='height:100px'><p></p></span><script>
window.onscroll = function() {animateNav()};
var navbar = document.getElementById('navbar');
var sticky = navbar.offsetTop;
const sections = document.querySelectorAll('section');
const navLi = document.querySelectorAll('.navbar a');

function animateNav() {
  if (window.pageYOffset >= sticky) {
    navbar.classList.add('sticky')
  } else {
    navbar.classList.remove('sticky');
  }
  var current = '';

  sections.forEach((section) => {
    const sectionTop = section.offsetTop;
    if (pageYOffset >= sectionTop - 60) {
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
</script></body>"

# create plots based on subject, cohort
YOUth_write_counts_html <- function(subject,cohort,nWaves,yMax) {
  cat("<div class='container' id='main'>")
  csvSize = dim(df)
  vars = array();
  n = 2:csvSize[1]
  iRow = 0
  for (i in n) { ## find first wave
    if (df[i,2] == cohort & df[i,4] == subject) { 
      currName = df[i,7]
      if (is.element(currName,vars)) {
        next # skip if already included
      }
      iRow = iRow + 1
      firstMatch = 0
      vars <- append(vars,currName)
      k = 2:csvSize[1]
      for (x in k) { ## find additional waves
        if (df[x,7] == currName & df[x,2] == cohort & df[x,4] == subject) {
          if (firstMatch == 0) {
            firstMatch = 1
            firstWave = df[x,3]
            randVal = round(runif(1,1,10)*10000);
            dispName = gsub('(.{1,20})(\\s|$)', '\\1<br>', currName)
            dispName = gsub("'", '', dispName)
            cat(paste0("<div id='",digest::digest(currName),randVal,"' class='plot'></div>\n"))
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
              
            cat(paste0(",",df[x,10],",'",df[x,3],"'"))
          } else {
            cat(paste0(",",df[x,10],",'",df[x,3],"'"))
          }
        }
      }
      cat(paste0(")</script>\n"))
      if (iRow > 6) {
        cat(paste0("</div><div class='container' id='main'>\n"))
        iRow = 0
      }
    }
  }
  cat("</div></section><hr>\n")
}

outputFile = paste0('prospectus_overview.html')
sink(outputFile)
cat(htmlHead)
cat('<section id="cac"><h2>Child & Adolescent: Children</h2>')
subject = "Kinderen"
cohort = "K&T"
YOUth_write_counts_html(subject,cohort,2,1500)

cat('<section id="cap"><h2>Child & Adolescent: Parents</h2>')
subject = "Ouders"
cohort = "K&T"
YOUth_write_counts_html(subject,cohort,2,1500)

cat('<section id="bcc"><h2>Baby & Children: Children</h2>')
subject = "Kinderen"
cohort = "B&K"
YOUth_write_counts_html(subject,cohort,3,1600)

cat('<section id="bcm"><h2>Baby & Children: Mothers</h2>')
subject = "Moeders"
cohort = "B&K"
YOUth_write_counts_html(subject,cohort,5,2500)

cat('<section id="bcp"><h2>Baby & Children: Partners</h2>')
subject = "Partners"
cohort = "B&K"
YOUth_write_counts_html(subject,cohort,5,1800)


cat(htmlTail)
closeAllConnections() 


