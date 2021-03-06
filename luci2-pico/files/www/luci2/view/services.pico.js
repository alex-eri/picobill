L.ui.view.extend({
	title: L.tr('Nases'),
	refresh: 60000,

	getNas: L.rpc.declare({
		object: 'pico.radius.nas',
		method: 'list',
		expect: { list: '' }
	}),

	execute: function() {
		return this.getSystemLog().then(function(list) {
			var ta = document.getElementById('map');
            for (line in list) ta.appendChild(line);
		});
	}
});
