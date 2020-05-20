<template>
  <article class='post'>
    <div
      @mouseover='showUserModal'
      @mouseleave='hideUserModal'
    >
      <div class='post__mouseover-zone--image' />
      <div class='post__mouseover-zone--name' />
      <post-user
        v-show='isUserModalActive'
        :item='item.user'
      />
    </div>
    <figure
      class='media-left post__image'
    >
      <user-avatar :avatar-key='item.user.avatarKey' />
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
  </article>
</template>

<script lang='ts'>
import PostUser from './postUser.vue'
import UserAvatar from './userAvatar.vue'

export default {
  components: { PostUser, UserAvatar },
  props: {
    item: {
      type: Object,
      default: (): object => ({}),
    },
  },
  data(): object {
    return {
      isUserModalActive: false,
    }
  },
  methods: {
    showUserModal(): void {
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
      width: 200px;
      height: 35px;
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
