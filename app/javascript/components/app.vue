<template>
  <div>
    <p>{{ message }}, {{ this.user.name }}</p>
    <ul>
      <li v-for="post in posts" :key="post.content">
        {{ post.user.name }}: {{ post.content }}
      </li>
    </ul>

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
      posts: '',
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
    posts: gql`query {
      posts {
        content
        user {
          id
          name
        }
      }
    }`,
  },
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
