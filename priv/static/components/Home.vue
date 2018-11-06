<template>
  <div class="app">
    <div>
      <div class="form-group">
        <h2>Hello Bootstrap</h2>
        <span class="fa fa-arrows"></span>
      </div>
    </div>
    <div class="example">
      <h3>Default datepicker...</h3>
      <datepicker placeholder="Select Date" />
    </div>
</div>
</template>

<script>
import Datepicker from 'vuejs-datepicker'

var state = {
  date: new Date(2016, 9,  16)
}

export default {
  name: 'home',
  components: {
    Datepicker
  },
}
</script>

<style lang="scss">
</style>
