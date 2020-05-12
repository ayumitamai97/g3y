<template>
  <div class='container'>
    <div class='columns'>
      <div class='column is-6'>
        <h2 class='title is-size-2'>Home Timeline</h2>
      </div>
      <div class='column is-6'>
        <input
         class='input' @keydown.enter='search' v-model='query.qKeyword'
         placeholder='Search by username or post content'
        >
      </div>
    </div>
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

const jpKeyCode: number = 13

export default {
  components: { Posts, newPostForm },
  data(): Object {
    return {
      query: { qKeyword: '' },
    }
  },
  created(): void {
    if (!authUtil.isAuthenticated()) {
      this.$router.push('/login')
    }
  },
  methods: {
    search(event): void {
      if (event.keyCode !== jpKeyCode) return

      this.$router.push({
        path: 'explore',
        query: { qKeyword: this.query.qKeyword, queryField: 'fuzzyPosts' },
      })
    },
  },
}
</script>
