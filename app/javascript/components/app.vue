<template>
  <div class="p-home">
    <h1 class="p-home__title">Home Timeline</h1>
    <div class="p-home__posts">
      <div v-for="post in posts" :key="post.id" class="p-home__posts__item c-post">
        <div class="c-post--username">{{ post.user.name }}</div>
        <div class="c-post--content">{{ post.content }}</div>
      </div>
    </div>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'

export default {
  data() {
    return {
      user: '',
      posts: '',
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

<style scoped lang="sass">
  .p-home {
    margin: 20px 15px;
    font-size: 16px;

    &__title {
      margin: 20px 0;
    }

    &__posts {
      margin: 20px 0;
    }
  }

  .c-post {
    margin: 15px 0;

    &--username {
      font-size: 0.75em;
    }

    &--content {
      font-size: 1em;
    }
  }
</style>
