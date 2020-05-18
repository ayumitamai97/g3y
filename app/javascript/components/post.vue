<template>
  <article class='post'>
    <!-- TODO: implement avatar -->
    <div
      class='post__mouseover-zone--name'
      @mouseover='showUserModal'
      @mouseleave='hideUserModal'
    />
    <div
      class='post__mouseover-zone--image'
      @mouseover='showUserModal'
      @mouseleave='hideUserModal'
    />
    <figure
      class='media-left post__image'
    >
      <img
        alt='avatar'
        src='https://pbs.twimg.com/profile_images/1127137125114056705/grUfEmX__400x400.jpg'
      >
    </figure>
    <div class='media-content post__content'>
      <div
        class='post__head'
      >
        <span
          class='has-text-weight-bold post__head--name'
        >{{ item.user.name }}</span>
        <span class='is-size-7 has-text-grey-light post__head--datetime'>{{ item.createdAt }}</span>
      </div>
      <div class='is-size-6 post__body'>
        {{ item.content }}
      </div>
    </div>
    <post-user
      v-show='isUserModalActive'
      :item='item.user'
    />
  </article>
</template>

<script lang='ts'>
import PostUser from './postUser.vue'

export default {
  components: { PostUser },
  props: {
    item: {
      type: Object,
      default: () => {},
    },
  },
  data() {
    return {
      isUserModalActive: false,
    }
  },
  methods: {
    async showUserModal() {
      this.isUserModalActive = true
    },
    hideUserModal(): void {
      this.isUserModalActive = false
    },
  },
}
</script>

<style lang='sass'>
.post {
  &__image {
    // TODO: allow users to upload avatar
    height: 50px;
    width: 50px;
  }

  &__head {
    margin-bottom: 5px;

    &--name {
      padding-right: 5px;
    }

    &--datetime {
      align-items: baseline;
    }
  }

  &__body {
    word-break: break-all;
  }

  &__mouseover-zone {
    &--name {
      width: 300px;
      height: 30px;
      position: absolute;
    }
    &--image {
      width: 55px;
      height: 55px;
      position: absolute;
    }
  }
}
</style>
