<template>
  <div>
    <p>{{ message }}, {{ userName() }}</p>

    <router-link to='/foo'>go to foo</router-link>
    <router-link to='/bar'>go to bar</router-link>

    <router-view></router-view>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'

export default {
  data() {
    return {
      user: '',
      message: 'Hello👋',
    }
  },
  apollo: {
    // TODO: ログイン中のユーザ
    user: gql`query {
      user(id: 1) {
        id
        name
      }
    }`,
  },
  methods: {
    userName() {
      return this.user.name
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
