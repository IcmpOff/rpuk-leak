window.CONFIG = {
	defaultTemplateId: 'default', //This is the default template for 2 args1
	defaultAltTemplateId: 'defaultAlt', //This one for 1 arg
	templates: { //You can add static templates here
		'default': '<b>{0}</b>: {1}',
		'defaultAlt': '{0}',
		'rpuk': '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(25, 25, 25, 0.6); border-radius: 3px;"><img style="position:absolute;right:0%;margin-top:auto;height:1.6vw;"src="https://www.roleplay.co.uk/images/rplogo.png" /> {0}</div>'
	},
	fadeTimeout: 7000,
	suggestionLimit: 5,
	style: {
		background: 'rgba(52, 73, 94, 0.7)',
		width: '38%',
		height: '22%',
	}
};
