<template>
  <div class='container'>
    <h2 class='title is-2'>Home Timeline</h2>
    <div>
      <posts></posts>
    </div>
  </div>
</template>

<script lang='ts'>
import Posts from './posts.vue'
import authUtil from '../src/authUtil.ts'

export default {
  components: { Posts },
  created() {
    if (!authUtil.isAuthenticated()) {
      this.$router.push('/login')
    }
  },
}
</script>
