// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function selectAllNone(c) {
	var f = $("manage_samples_form");
	var fc = f.getInputs( "checkbox")
	fc.findAll( function(i) {
			i.checked = c;
		}
		);
	selectedSamplesNo()
}

function selectedSamplesNo() {
	var x = 0;
	var f = Form.getInputs("manage_samples_form", "checkbox")
	f.without(f[0]).findAll( function(i) {
			if(i.checked) {
				x = x + 1;
			}
	} );
	if(x == 0) {
		$('manage_samples_form').update_btn.disable();
		$('manage_samples_form').destroy_multiple_btn.disable();
	} else {
		$('manage_samples_form').update_btn.enable();
		$('manage_samples_form').destroy_multiple_btn.enable();
	}	
	$('selected_samples_no').update(x + " samples");
}

function verifyImportData() {
	var $data = $('samples_import').value
	var $data_arr = $data.split(/\n/);
	var $rows = new Array();
	var $delim = '';
	if ($('format_csv').checked) {
			$delim = ',';
	} else {
			$delim = '\t';
	}
	//alert($data_arr.size());
	$data_arr.each( function(i) {
										var $cols= new Array();
										i.split($delim).each( function(x) {
											$cols.push("<td>" + x.strip() + "</td>");
										} );
										$rows.push( "<tr>" + $cols.join("") + "</tr>" );
									} );

	drawVerifiedData($rows.join("\n"));
}

function drawVerifiedData($r) {
	$table = "<table border='1' width='100%' style='font-size: small;'>" + 
					"<tr><th>Tube number</th><th>Sample name</th><th>Sample origin</th><th>Sample date</th><th>Provider</th><th>Description</th><th>Analysis type</th></tr>" + $r + "</table>";
	$('check').update($table);
	new Effect.Highlight( 'check' );
	$('import_btn').show();
}

