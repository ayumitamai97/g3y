<template>
  <div>
    <p>{{ message }}</p>
    <router-link to='/foo'>go to foo</router-link>
    <router-link to='/bar'>go to bar</router-link>
    <router-view></router-view>
  </div>
</template>

<script lang='ts'>
export default {
  data() {
    return {
      message: 'Hello👋',
    }
  },
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
