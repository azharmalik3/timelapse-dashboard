<template>
  <div id="video-player">
    <video
      controls
      autoplay
      :src="video"
    ></video>
  </div>
</template>

<script>
import Vue from 'vue'
import App from './App.vue'
const app = new Vue(App)

export default {
  name: 'gallery',
  data() {
    return {
      video: ""
    }
  },
  mounted() {
    this.playVideo()
  },
  methods: {
      playVideo() {
        this.$http.get('/watch/single/' + this.$route.params.id, {
          headers: {
            'x-csrf-token': this.csrf_token
          }
        }).then(response => {
          this.video = response.body.url
        }).catch(function (error) {
          app.$notify({group: 'notify', title: 'Something went wrong.', type: 'error'});
        });
      }
    }
  }
</script>

<style lang="scss">
</style>
