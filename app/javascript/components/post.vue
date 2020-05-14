<template>
  <article class='post'>
    <figure class='media-left post__image'>
      <!-- TODO: implement avatar -->
      <img
        alt='avatar'
        src='https://pbs.twimg.com/profile_images/1127137125114056705/grUfEmX__400x400.jpg'
      >
    </figure>
    <div class='media-content post__content'>
      <div class='post__head'>
        <span class='has-text-weight-bold post__head--name'>{{ item.user.name }}</span>
        <span class='is-size-7 has-text-grey-light post__head--datetime'>{{ item.createdAt }}</span>
      </div>
      <div class='is-size-6 post__body'>
        {{ item.content }}
      </div>
    </div>
  </article>
</template>

<script lang='ts'>
export default {
  props: {
    item: {
      type: Object,
      default: () => {},
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
}
</style>
