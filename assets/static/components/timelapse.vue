<template>
  <div class="page_content">
    <form
      class="row"
      @submit="checkForm"
      method="post"
    >
      <p v-if="errors.length">
        <b>Please correct the following error(s):</b>
        <ul>
          <li v-for="error in errors">{{ error }}</li>
        </ul>
      </p>

      <input type="hidden" name="_csrf_token" :value="csrf_token">

      <div class="col-sm-6">
        <div class="form-group">
          <label for="title">title</label>
          <input
            class="form-control"
            aria-describedby="emailHelp"
            splaceholder="Enter email"
            id="title"
            v-model="title"
            type="text"
            name="title"
          >
        </div>

        <div class="form-group">
          <label for="camera">Camera</label>
          <input
            class="form-control"
            aria-describedby="emailHelp"
            splaceholder="Enter email"
            id="camera"
            v-model="camera"
            type="text"
            name="camera"
          >
        </div>

        <div class="form-group">
          <label for="from">From date</label>
          <datepicker
            :bootstrap-styling="true"
            id="from"
            v-model="from"
            name="from"
          ></datepicker>
        </div>

        <div class="form-group">
          <label for="from">To date</label>
          <datepicker
            :bootstrap-styling="true"
            id="to"
            v-model="to"
            name="to"
          ></datepicker>
        </div>

        <div class="form-group">
          <label for="interval">Interval</label>
          <select
            class="custom-select"
            id="interval"
            v-model="interval"
            name="interval"
          >
            <option v-for="option in op_interval" v-bind:value="option.value">
              {{ option.text }}
            </option>
          </select>
        </div>
        <div class="form-group">
          <label for="schedule">Schedule</label>
          <select
            class="custom-select"
            id="schedule"
            v-model="schedule"
            name="schedule"
          >
            <option v-for="option in op_schedule" v-bind:value="option.value">
              {{ option.text }}
            </option>
          </select>
        </div>

        <div class="form-group">
          <label for="mp4">MP4</label>
          <select
            class="custom-select"
            id="mp4"
            v-model="mp4"
            name="mp4"
          >

            <option value="true">True</option>
            <option value="false" selected="selected">False</option>
          </select>
        </div>


        <div class="form-group">
          <label for="watermark_logo">Select the logo</label>
          <input
            id="watermark_logo"
            class="form-control-file"
            type="file"
            @change="onFileChange">
        </div>

        <div class="form-group">
          <label for="watermark_position">Logo position</label>
          <select
            class="custom-select"
            id="watermark_position"
            v-model="watermark_position"
            name="watermark_position"
          >
            <option v-for="option in op_position" v-bind:value="option.value">
              {{ option.text }}
            </option>
          </select>
        </div>
      </div>

      <div class="col-sm-6">

      </div>
      <p>
        <input
          class="btn btn-block btn-primary"
          type="submit"
          value="Submit"
        >
      </p>
    </form>
  </div>
</template>

<script>
import Vue from 'vue'
import App from './App.vue'
const app = new Vue(App)
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'timelapse',
  components: {
    Datepicker

  },
  data: function() {
    return{
      errors: [],
      camera: null,
      from: null,
      to: null,
      interval: null,
      schedule: null,
      mp4: null,
      watermark_logo: null,
      title: null,
      watermark_position: null,
      csrf_token: $('meta[name="csrf-token"]').attr("content"),
      selected: '5',
      op_interval: [
        { text: 'All', value: '' },
        { text: '1 Frame Every 5 seconds', value: '5' },
        { text: '1 Frame Every 10 seconds', value: '10' },
        { text: '1 Frame Every 15 seconds', value: '15' },
        { text: '1 Frame Every 20 seconds', value: '20' },
        { text: '1 Frame Every 30 seconds', value: '30' },
        { text: '1 Frame Every 1 min', value: '60' },
        { text: '1 Frame Every 5 min', value: '300' },
        { text: '1 Frame Every 10 min', value: '600' },
        { text: '1 Frame Every 15 min', value: '900' },
        { text: '1 Frame Every 20 min', value: '1200' },
        { text: '1 Frame Every 30 min', value: '1800' },
        { text: '1 Frame Every hour', value: '3600' },
        { text: '1 Frame Every 2 hours', value: '7200' },
        { text: '1 Frame Every 6 hours', value: '21600' },
        { text: '1 Frame Every 12 hours', value: '43200' },
        { text: '1 Frame Every 24 hours', value: '86400' }
      ],
      op_position: [
        { text: 'Botton-left', value: '0' },
        { text: 'Top-right', value: '1' },
        { text: 'Botton-right', value: '2' },
        { text: 'Top-left', value: '3' }
      ],
      op_schedule: [
        { text: 'Continuous', value: 'full_week' },
        { text: 'Working Hours', value: 'working_hours' },
        { text: 'On Schedule', value: 'random_hours' }
      ]
    }
  },
  methods: {
    checkForm: function (e) {
      if (this.camera && this.from && this.to) {
        let formData = new FormData();
        formData.append('camera', this.camera)
        formData.append('from', this.from)
        formData.append('to', this.to)
        formData.append('title', this.title)
        formData.append('interval', this.interval)
        formData.append('schedule', this.schedule)
        formData.append('mp4',this.mp4)
        formData.append('watermark_position',this.watermark_position)
  			formData.append('watermark_logo',this.watermark_logo)
        this.$http.post('/timelapse', formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
            'x-csrf-token': this.csrf_token
          }
        }).then(function (response) {
          if (response.body.status != 0) {
            app.$notify({group: 'notify', title: response.body.error_text, type: 'error'});
          }else{
            app.$notify({group: 'notify', title: 'Your message has been sent.'});
          }
          //this.clearForm();
        }).catch(function (error) {
          app.$notify({group: 'notify', title: 'Something went wrong.', type: 'error'});
          //this.clearForm();
        });
      }

      if (!this.camera) {
        this.$notify({
          group: 'notify',
          type: 'warn',
          title: 'Important message',
          text: 'Camera required'
        })
      }
      if (!this.from) {
        this.$notify({
          group: 'notify',
          type: 'warn',
          title: 'Important message',
          text: 'From required.'
        })
      }
      if (!this.to) {
        this.$notify({
          group: 'notify',
          type: 'warn',
          title: 'Important message',
          text: 'To required.'
        })
      }

      e.preventDefault();
    },
    clearForm: function() {
      this.smsMessage = "";
      this.toNumber = "";
      this.smsMessage_text = "";
    },
    onFileChange(e) {
      this.watermark_logo = e.target.files[0]
    }
  }
}
</script>

<style lang="scss">
</style>
