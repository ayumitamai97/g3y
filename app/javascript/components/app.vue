<template>
  <div class="p-home">
    <h1 class="p-home__title">Home Timeline</h1>
    <div class="p-home__posts">
      <posts></posts>
    </div>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'
import Posts from './posts'

export default {
  data() {
    return {
      user: '',
    }
  },
  components: { Posts },
  apollo: {
    // TODO: ログイン中のユーザ
    user: gql`query {
      user(id: 1) {
        id
        name
      }
    }`,
  },
}
</script>
