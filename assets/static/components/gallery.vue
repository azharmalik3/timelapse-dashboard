<template>
  <div class="container-fluid">
    <div class="animated fadeIn">
      <div class="row">
        <div v-for="video in videos" class="col-sm-6 col-md-4">
          <div class="card">
            <div class="collapse show" id="collapseExample">
              <div class="card-body">
                <router-link :to="{path: '/watch/' + video.id}">
                  <img src="/images/image1.png"></img>
                </router-link>
              </div>
            </div>
            <div class="card-header">{{video.title}}
              <div class="card-header-actions">
                <a class="card-header-action btn-setting">
                  <i class="fa fa-ellipsis-v"></i>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import App from './App.vue'
const app = new Vue(App)

export default {
  name: 'gallery',
  data: function() {
    return{
      errors: [],
      videos: ""
    }
  },
  methods: {
    getVideos: function () {
      this.$http.get('/gallery/json', {
        headers: {
          'x-csrf-token': this.csrf_token
        }
      }).then(response => {
        this.videos = response.body.logs
      }).catch(function (error) {
        app.$notify({group: 'notify', title: 'Something went wrong.', type: 'error'});
      });
    }
  },
  mounted(){
    this.getVideos()
  }
}
</script>

<style lang="scss">
</style>
