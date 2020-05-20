<template>
  <article class='user'>
    <figure class='media-left user__image'>
      <user-avatar :user-id='item.id' />
    </figure>
    <div class='media-content user__name has-text-weight-bold'>
      {{ item.name }}
    </div>
    <follow-button :following-id='item.id' />
  </article>
</template>

<script lang='ts'>
import FollowButton from './followButton.vue'
import UserAvatar from './userAvatar.vue'

export default {
  components: { FollowButton, UserAvatar },
  props: {
    item: {
      type: Object,
      default: (): object => ({ id: '', name: '' }),
    },
  },
}
</script>

<style lang='sass'>
.user {
  &__image {
    height: 50px;
    width: 50px;
  }
}
</style>
