function draw_ratio_to_original_size(data) {
  var traces = [];
  traces.push(getTrace("tar_gz", data.tar_gz));
  traces.push(getTrace("tar_bz", data.tar_bz));
  traces.push(getTrace("lz4", data.lz4));
  traces.push(getTrace("xz", data.xz));
  traces.push(getTrace("7z", data._7z));
  traces.push(getTrace("kgb", data.kgb));

  var layout = {
    title:'Współczynnik kompresji do rozmiaru pliku',
    yaxis: {
      tickformat: ',.0%',
      range: [0,1]
    }
  };

  Plotly.plot('graph_ratio_to_original_size', traces, layout);
}

function getTrace(compression_name, compressed_files_data) {
  let x = [], y = [], names = [];
  for(let compressed_file of compressed_files_data) {
    x.push(compressed_file.uncompressed_file_size);
    y.push(compressed_file.compression_ratio);
    names.push(compressed_file.name.toString());
  }

  var trace = {
    x: x,
    y: y,
    mode: 'markers', //+text
    type: 'scatter',
    name: compression_name,
    text: names,
    textposition: 'top center',
    marker: { size: 12 }
  };

  return trace;
}
