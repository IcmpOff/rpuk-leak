<template>
	<body>
		<audio id="audio_on" src="audio_on.ogg"></audio>
		<audio id="audio_off" src="audio_off.ogg"></audio>
		<audio id="radio_on" src="radio_on.ogg"></audio>
		<audio id="radio_off" src="radio_off.ogg"></audio>
		<audio id="radio_panic" src="radio_panic.ogg"></audio>

		<div class="voiceInfo">
			<p v-if="voice.callInfo !== 0" :class="{ talking: voice.talking }">
				[Call]
			</p>
			<p v-if="voice.radioEnabled && voice.radioChannel !== 0" :class="{ talking: voice.usingRadio }">
				[Radio] {{ voice.radioChannelLabel }} - Volume: {{ voice.radioVolume }}
			</p>
			<p v-if="voice.voiceModes.length" :class="{ talking: voice.talking }">
				[ID: {{ voice.playerId }}] {{ voice.voiceModes[voice.voiceMode][1] }}
			</p>
		</div>
	</body>
</template>

<script>
import { reactive } from "vue";
export default {
	name: "App",
	setup() {
		const voice = reactive({
			voiceModes: [],
			voiceMode: 0,
			radioChannel: 0,
			radioChannelLabel: 0,
			radioChannelOverrides: [],
			radioEnabled: false,
			radioVolume: 1.0,
			usingRadio: false,
			callInfo: 0,
			talking: false,
			playerId: 0
		});

		// stops from toggling voice at the end of talking
		let usingUpdated = false
		window.addEventListener("message", function(event) {
			const data = event.data;

			if (data.voiceModes !== undefined) {
				voice.voiceModes = JSON.parse(data.voiceModes);
			}

			if (data.playerId !== undefined) {
				voice.playerId = data.playerId;
			}

			if (data.voiceMode !== undefined) {
				voice.voiceMode = data.voiceMode;
			}

			if (data.radioChannelOverrides !== undefined) {
				voice.radioChannelOverrides = JSON.parse(data.radioChannelOverrides);
			}

			if (data.radioChannel !== undefined) {
				voice.radioChannel = data.radioChannel;

				if (voice.radioChannelOverrides[voice.radioChannel - 1]) {
					voice.radioChannelLabel = voice.radioChannelOverrides[voice.radioChannel - 1];
				} else {
					voice.radioChannelLabel = `${voice.radioChannel} MHz`
				}
			}

			if (data.radioEnabled !== undefined) {
				voice.radioEnabled = data.radioEnabled;
			}

			if (data.radioVolume !== undefined) {
				voice.radioVolume = data.radioVolume;
			}

			if (data.callInfo !== undefined) {
				voice.callInfo = data.callInfo;
			}

			if (data.usingRadio !== voice.usingRadio) {
				usingUpdated = true
				voice.usingRadio = data.usingRadio
				setTimeout(function(){
					usingUpdated = false
				}, 100)
			}

			if ((data.talking !== undefined) && !voice.usingRadio && !usingUpdated){
				voice.talking = data.talking
			}

			if (data.sound && voice.radioEnabled) {
				let click = document.getElementById(data.sound);
				// discord these errors as its usually just a 'uncaught promise' from two clicks happening too fast.
				click.load();
				click.volume = data.volume;
				click.play().catch((e) => {});
			}
		});

		return { voice };
	},
};
</script>

<style>
.voiceInfo {
	font-family: Arial;
	position: absolute;
	top: 0%;
	left: 0%;
	text-align: left;
	padding: 5px;
	font-weight: bold;
	color: rgb(1, 176, 240);
	font-size: 0.5vw;
}

.talking {
	color: rgba(244, 196, 65, 255);
}

p {
	margin: 0;
}
</style>
