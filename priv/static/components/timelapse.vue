<template>
  <div>
    <form
      @submit="checkForm"
      action="https://vuejs.org/"
      method="post"
    >

      <p v-if="errors.length">
        <b>Please correct the following error(s):</b>
        <ul>
          <li v-for="error in errors">{{ error }}</li>
        </ul>
      </p>

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
          <option value="">Select Interval</option>
          <option value="0">All</option>
          <option value="5">1 Frame Every 5 seconds</option>
          <option value="10">1 Frame Every 10 seconds</option>
          <option value="15">1 Frame Every 15 seconds</option>
          <option value="20">1 Frame Every 20 seconds</option>
          <option value="30">1 Frame Every 30 seconds</option>
          <option value="60">1 Frame Every 1 min</option>
          <option value="300">1 Frame Every 5 min</option>
          <option selected="selected" value="600">1 Frame Every 10 min</option>
          <option value="900">1 Frame Every 15 min</option>
          <option value="1200">1 Frame Every 20 min</option>
          <option value="1800">1 Frame Every 30 min</option>
          <option value="3600">1 Frame Every hour</option>
          <option value="7200">1 Frame Every 2 hours</option>
          <option value="21600">1 Frame Every 6 hours</option>
          <option value="43200">1 Frame Every 12 hours</option>
          <option value="86400">1 Frame Every 24 hours</option>
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
          <option value="full_week">Continuous</option>
          <option value="working_hours" selected="selected">Working Hours</option>
          <option value="random_hours">On Schedule</option>
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

      <p>
        <input
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
      mp4: null

    }
  },
  methods: {
    checkForm: function (e) {
      if (this.camera && this.from && this.to) {
        return true;
      }

      this.errors = [];

      if (!this.camera) {
        this.errors.push('Camera required.');
      }
      if (!this.from) {
        this.errors.push('From required.');
      }
      if (!this.to) {
        this.errors.push('To required.');
      }

      e.preventDefault();
    }
  }
}
</script>

<style lang="scss">
</style>
