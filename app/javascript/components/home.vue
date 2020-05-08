<template>
  <div class='container'>
    <h2 class='title is-size-2'>Home Timeline</h2>
    <new-post-form></new-post-form>
    <div>
      <posts></posts>
    </div>
  </div>
</template>

<script lang='ts'>
import Posts from './posts.vue'
import newPostForm from './newPostForm.vue'
import authUtil from '../src/authUtil.ts'

export default {
  components: { Posts, newPostForm },
  created() {
    if (!authUtil.isAuthenticated()) {
      this.$router.push('/login')
    }
  },
}
</script>
