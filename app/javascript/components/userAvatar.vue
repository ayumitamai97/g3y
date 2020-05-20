<template>
  <img
    :src='imageSrc'
    alt='avatar'
    class='user-avatar'
  >
</template>

<script lang='ts'>
import gql from 'graphql-tag'

export default {
  props: {
    userId: {
      type: String,
      default: null,
    },
  },
  data(): object {
    return {
      imageSrc: '',
    }
  },
  apollo: {
    user: {
      query: gql`query user($id: ID) {
        user (id: $id) {
          avatarKey
        }
      }`,
      variables(): object {
        return {
          id: this.userId,
        }
      },
      result({ data }): void {
        if (!data) return
        const { avatarKey } = data.user
        if (avatarKey) {
          this.imageSrc = `https://${process.env.AWS_BUCKET}.s3-${process.env.AWS_REGION}.amazonaws.com/${avatarKey}`
        } else {
          this.imageSrc = `https://${process.env.AWS_BUCKET}.s3-${process.env.AWS_REGION}.amazonaws.com/icons/default.png`
        }
      },
    },
  },
}
</script>

<style lang='sass'>
.user-avatar {
  height: 50px;
  width: 50px;
  border-radius: 25px;
  object-fit: cover;
}
</style>
