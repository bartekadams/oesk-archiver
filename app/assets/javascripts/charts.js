function draw_ratio_to_original_size(data, chart_html_id, title) {
  var traces = [];
  traces.push(get_ratio_to_original_size_trace("tar_gz", data.tar_gz));
  traces.push(get_ratio_to_original_size_trace("tar_bz", data.tar_bz));
  traces.push(get_ratio_to_original_size_trace("lz4", data.lz4));
  traces.push(get_ratio_to_original_size_trace("xz", data.xz));
  traces.push(get_ratio_to_original_size_trace("7z", data._7z));
  traces.push(get_ratio_to_original_size_trace("kgb", data.kgb));

  var layout = {
    title: title,
    titlefont: {
      size: 25
    },
    yaxis: {
      title: 'Stopień kompresji',
      tickformat: ',.0%',
      range: [0,1.05]
    },
    xaxis: {
      title: "Rozmiar pliku"
    }
  };

  Plotly.plot(chart_html_id, traces, layout);
}

function get_ratio_to_original_size_trace(compression_name, compressed_files_data) {
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

function draw_time_to_original_size(data, chart_html_id, title) {
  var traces = [];
  traces.push(get_time_to_original_size_trace("tar_gz", data.tar_gz));
  traces.push(get_time_to_original_size_trace("tar_bz", data.tar_bz));
  traces.push(get_time_to_original_size_trace("lz4", data.lz4));
  traces.push(get_time_to_original_size_trace("xz", data.xz));
  traces.push(get_time_to_original_size_trace("7z", data._7z));
  traces.push(get_time_to_original_size_trace("kgb", data.kgb));

  var layout = {
    title: title,
    titlefont: {
      size: 25
    },
    yaxis: {
      title: 'Czas kompresji [ms]'
    },
    xaxis: {
      title: "Rozmiar pliku"
    }
  };

  Plotly.plot(chart_html_id, traces, layout);
}

function get_time_to_original_size_trace(compression_name, compressed_files_data) {
  let x = [], y = [], names = [];
  for(let compressed_file of compressed_files_data) {
    x.push(compressed_file.uncompressed_file_size);
    y.push(Math.round(compressed_file.compression_time));
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

function draw_ratio_to_type(data, chart_html_id, title) {
  var y = [];
  y.push(get_ratio_to_type_trace("tar_gz", data.tar_gz));
  y.push(get_ratio_to_type_trace("tar_bz", data.tar_bz));
  y.push(get_ratio_to_type_trace("lz4", data.lz4));
  y.push(get_ratio_to_type_trace("xz", data.xz));
  y.push(get_ratio_to_type_trace("7z", data._7z));
  y.push(get_ratio_to_type_trace("kgb", data.kgb));

  var x = ['tar_gz', 'tar_bz', 'lz4', 'xz', '7z', 'kgb'];

  var layout = {
    title: title,
    titlefont: {
      size: 25
    },
    yaxis: {
      title: 'Stopień kompresji',
      tickformat: ',.0%',
      range: [0,1]
    },
    xaxis: {
      title: "Typ kompresji"
    }
  };

  var trace = [{
    x: x,
    y: y,
    mode: 'markers',
    type: 'bar',
    //name: compression_name,
    //text: names,
    textposition: 'top center',
    marker: { size: 12 }
  }];

  Plotly.plot(chart_html_id, trace, layout);
}

function get_ratio_to_type_trace(compression_name, compressed_files_data) {
  let ratio = 0.0;
  for(let compressed_file of compressed_files_data) {
    ratio += compressed_file.compression_ratio;
    //names.push(compressed_file.name.toString());
  }
  return (ratio / compressed_files_data.length);
}
