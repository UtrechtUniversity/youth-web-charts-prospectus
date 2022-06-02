function create_plot_2(e, a, t, r, i, o, l, n) {
    1 == e ? (showTicks = !0, marginLeft = 80) : (showTicks = !1, marginLeft = 30), trace1.y = [i], trace2.y = [l], trace1.name = o, trace2.name = n;
    var s = [trace1, trace2],
        c = {
            plot_bgcolor: '#f6f6f6',
            paper_bgcolor: '#f6f6f6',
            margin: {
                l: marginLeft,
                r: marginRight,
                b: marginBottom,
                t: marginTop,
                pad: 4
            },
            showlegend: !1,
            title: r,
            barmode: 'grouped',
            hoverlabel: {
                font: {
                    size: 16
                }
            },
            font: {
                size: titleSize,
                family: 'Helvetica, sans-serif'
            },
            xaxis: {
                fixedrange: !0,
                showticklabels: !1
            },
            yaxis: {
                title: '',
                titlefont: {
                    family: 'Helvetica, sans-serif',
                    size: 12,
                    color: 'grey'
                },
                range: [0, a],
                fixedrange: !0,
                showgrid: !0,
                zeroline: !0,
                showline: !1,
                zerolinewidth: 2,
                zerolinecolor: '#42414C',
                showticklabels: showTicks,
                tickfont: {
                    size: 12,
                    family: 'Helvetica, sans-serif'
                }
            },
            legend: {
                font: {
                    size: 12,
                    family: 'Helvetica, sans-serif'
                }
            }
        };
    Plotly.newPlot(t, s, c)
}

function create_plot_3(e, a, t, r, i, o, l, n, s, c) {
    1 == e ? (showTicks = !0, marginLeft = 80) : (showTicks = !1, marginLeft = 30), trace1.y = [i], trace2.y = [l], trace3.y = [s], trace1.name = o, trace2.name = n, trace3.name = c;
    var f = [trace1, trace2, trace3],
        m = {
            plot_bgcolor: '#f6f6f6',
            paper_bgcolor: '#f6f6f6',
            margin: {
                l: marginLeft,
                r: marginRight,
                b: marginBottom,
                t: marginTop,
                pad: 4
            },
            showlegend: !1,
            title: r,
            barmode: 'grouped',
            hoverlabel: {
                font: {
                    size: 16
                }
            },
            font: {
                size: titleSize,
                family: 'Helvetica, sans-serif'
            },
            xaxis: {
                fixedrange: !0,
                showticklabels: !1
            },
            yaxis: {
                title: '',
                titlefont: {
                    family: 'Helvetica, sans-serif',
                    size: 12,
                    color: 'grey'
                },
                range: [0, a],
                fixedrange: !0,
                showgrid: !0,
                zeroline: !0,
                showline: !1,
                zerolinewidth: 2,
                zerolinecolor: '#42414C',
                showticklabels: showTicks,
                tickfont: {
                    size: 12,
                    family: 'Helvetica, sans-serif'
                }
            },
            legend: {
                font: {
                    size: 12,
                    family: 'Helvetica, sans-serif'
                }
            }
        };
    Plotly.newPlot(t, f, m)
}

function create_plot_5(e, a, t, r, i, o, l, n, s, c, f, m, g, y) {
    1 == e ? (showTicks = !0, marginLeft = 80) : (showTicks = !1, marginLeft = 30), trace1.y = [i], trace2.y = [l], trace3.y = [s], trace4.y = [f], trace5.y = [g], trace1.name = o, trace2.name = n, trace3.name = c, trace4.name = m, trace5.name = y;
    var h = [trace1, trace2, trace3, trace4, trace5],
        p = {
            plot_bgcolor: '#f6f6f6',
            paper_bgcolor: '#f6f6f6',
            margin: {
                l: marginLeft,
                r: marginRight,
                b: marginBottom,
                t: marginTop,
                pad: 4
            },
            showlegend: !1,
            title: r,
            barmode: 'grouped',
            hoverlabel: {
                font: {
                    size: 16
                }
            },
            font: {
                size: titleSize,
                family: 'Helvetica, sans-serif'
            },
            xaxis: {
                showticklabels: !1,
                fixedrange: !0
            },
            yaxis: {
                title: '',
                titlefont: {
                    family: 'Helvetica, sans-serif',
                    size: 12,
                    color: 'grey'
                },
                range: [0, a],
                fixedrange: !0,
                showgrid: !0,
                zeroline: !0,
                showline: !1,
                zerolinewidth: 2,
                zerolinecolor: '#42414C',
                showticklabels: showTicks,
                tickfont: {
                    size: 12,
                    family: 'Helvetica, sans-serif'
                }
            },
            legend: {
                font: {
                    size: 12,
                    family: 'Helvetica, sans-serif'
                }
            }
        };
    Plotly.newPlot(t, h, p)
}
titleSize = 12, marginRight = 10, marginBottom = 20, marginTop = 60, waveColors = ['#E43038', '#ED7539', '#FABD6B', '#FDC61A', '#FFE10C'], trace1 = {
    name: 'Wave 1',
    type: 'bar',
    marker: {
        color: waveColors[0],
        opacity: .9
    },
    hovertemplate: '%{y}'
}, trace2 = {
    name: 'Wave 2',
    type: 'bar',
    marker: {
        color: waveColors[1],
        opacity: .9
    },
    hovertemplate: '%{y}'
}, trace3 = {
    name: 'Wave 3',
    type: 'bar',
    marker: {
        color: waveColors[2],
        opacity: .9
    },
    hovertemplate: '%{y}'
}, trace4 = {
    name: 'Wave 4',
    type: 'bar',
    marker: {
        color: waveColors[3],
        opacity: .9
    },
    hovertemplate: '%{y}'
}, trace5 = {
    name: 'Wave 5',
    type: 'bar',
    marker: {
        color: waveColors[4],
        opacity: .9
    },
    hovertemplate: '%{y}'
};
function create_modal(e, l, n, a, k) {
    var url = 'https://staticweb.hum.uu.nl/youth/data/descriptions/' + a + '.pdf';
    function doesFileExist(urlToFile) {
      var xhr = new XMLHttpRequest();
      xhr.open('HEAD', urlToFile, false);
      xhr.send();
     
      if (xhr.status == "404") {
          return false;
      } else {
          return true;
      }
    }
    baseLink = '<br /><br /><div style="width:50%"><ul class="list-group"><li class="list-group-item"><i class="bi bi-link-45deg"></i> <a href="https://www.sciencedirect.com/science/article/pii/S1878929320301183?via%3Dihub" target="blank">Read cohort profile paper</a></li></ul></div>'
    if (n == 'MRI') {
      modalLinks = '<br /><br /><div style="width:50%"><ul class="list-group"><li class="list-group-item"><i class="bi bi-file-earmark-pdf"></i><span data-bs-toggle="tooltip" data-bs-placement="top" title="Download PDF"> <a href="' + url + '" target="blank">Download detailed description</span></a></li><li class="list-group-item"><i class="bi bi-link-45deg"></i> <a href="https://www.sciencedirect.com/science/article/pii/S1878929320300645?via%3Dihub" target="blank">Read MRI protocol paper</a></li><li class="list-group-item"><i class="bi bi-link-45deg"></i> <a href="https://www.sciencedirect.com/science/article/pii/S1878929320301183?via%3Dihub" target="blank">Read cohort profile paper</a></li></ul></div>'
    } else {
      modalLinks = '<br /><br /><div style="width:50%"><ul class="list-group"><li class="list-group-item"><i class="bi bi-file-earmark-pdf"></i><span data-bs-toggle="tooltip" data-bs-placement="top" title="Download PDF"> <a href="' + url + '" target="blank">Download detailed description</span></a></li><li class="list-group-item"><i class="bi bi-link-45deg"></i> <a href="https://www.sciencedirect.com/science/article/pii/S1878929320301183?via%3Dihub" target="blank">Read cohort profile paper</a></li></ul></div>'
    }
    if (doesFileExist(url)) { 
       modalContent = l + modalLinks + '<br /><br /><span class=grey><small><i class="bi bi-tag-fill"></i> ' + n + '&nbsp; <i class="bi bi-person-lines-fill"></i> ' + k + '&nbsp; <i class="bi bi-info-circle"></i><span data-bs-toggle="tooltip" data-bs-placement="top" title="Prospectus item code">' + a + '</span></small>'
    } else { 
       modalContent = l + baseLink + '<br/><br/><span class=grey><small><i class="bi bi-tag-fill"></i> ' + n + '&nbsp; <i class="bi bi-person-lines-fill"></i> ' + k + '&nbsp; <i class="bi bi-info-circle"></i><span data-bs-toggle="tooltip" data-bs-placement="top" title="Prospectus item code">' + a + '</span></small>'
    }
     $('#expModal').modal('toggle'), document.getElementById('modalBody').innerHTML = modalContent, document.getElementById('modalTitle').innerHTML = e 
};
