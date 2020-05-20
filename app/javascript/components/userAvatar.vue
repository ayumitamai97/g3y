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
    avatarKey: {
      type: String,
      default: null,
    },
  },
  data(): object {
    return {
      imageSrc: '',
      skipFetchAvatar: true,
    }
  },
  computed: {
    defaultIconSrc(): string {
      return `https://${process.env.AWS_BUCKET}.s3-${process.env.AWS_REGION}.amazonaws.com/icons/default.png`
    },
  },
  created(): void {
    if (this.avatarKey && this.avatarKey !== '') {
      this.imageSrc = `https://${process.env.AWS_BUCKET}.s3-${process.env.AWS_REGION}.amazonaws.com/${this.avatarKey}`
    } else if (this.userId) {
      this.$apollo.queries.user.skip = false
      this.$apollo.queries.user.refetch()
    } else {
      this.imageSrc = this.defaultIconSrc
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

        const fetchedAvatarKey = data.user.avatarKey
        if (fetchedAvatarKey) {
          this.imageSrc = `https://${process.env.AWS_BUCKET}.s3-${process.env.AWS_REGION}.amazonaws.com/${fetchedAvatarKey}`
        } else {
          this.imageSrc = this.defaultIconSrc
        }
      },
      skip: true,
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
