<template>
  <div class='container'>
    <h2 class='title is-size-2 has-text-grey-dark'>
      Your Profile
    </h2>
    <errors :errors='errors' />
    <successes :successes='notifications' />
    <div class='field'>
      <div class='control'>
        <div class='file'>
          <label class='file-label'>
            <input
              type='file'
              class='file-input'
              @input='upload'
            >
            <span class='file-cta'>
              <span class='file-icon'>
                <font-awesome-icon :icon='["fas", "image"]' />
              </span>
              <span class='file-label'>
                Upload profile image
              </span>
            </span>
          </label>
        </div>
      </div>
    </div>
    <div class='field'>
      <div class='control'>
        <img :src='imageSrc'>
      </div>
    </div>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faImage } from '@fortawesome/free-solid-svg-icons'
import Errors from './errors.vue'
import Successes from './successes.vue'

library.add(faImage)

export default {
  components: { Errors, Successes },
  data(): object {
    return {
      errors: [],
      notifications: [],
      imageSrc: '',
    }
  },
  apollo: {
    user: {
      query: gql`query { user { avatarKey } }`,
      result({ data }): void {
        if (!data) return
        const { avatarKey } = data.user
        if (avatarKey) {
          this.imageSrc = `https://${process.env.AWS_BUCKET}.s3-${process.env.AWS_REGION}.amazonaws.com/${avatarKey}`
        }
      },
    },
  },
  methods: {
    upload(event): void {
      const { userName } = this.$store.state
      const key: string = `icons/${userName}_${Date.now()}.jpg`
      const requestObject: object = {
        Key: key,
        Bucket: process.env.AWS_BUCKET,
        Body: event.target.files[0],
      }
      const callback: object = async (err): Promise<void> => {
        if (err) {
          this.errors.push(err)
        } else {
          await this.updateUser(key)
        }
      }
      this.$s3.putObject(requestObject, callback)
    },
    async updateUser(avatarKey): Promise<void> {
      const request = this.$apollo.mutate({
        mutation: gql`mutation updateUser($avatarKey: String!) {
          updateUser(input: { avatarKey: $avatarKey }) {
            user {
              id
            }
            errors
          }
        }`,
        variables: {
          avatarKey,
        },
      })
      const { data } = await request
      if (data.updateUser.user) {
        this.notifications.push('Successfully uploaded image')
        this.imageSrc = `https://${process.env.AWS_BUCKET}.s3-${process.env.AWS_REGION}.amazonaws.com/${avatarKey}`
      } else if (data.updateUser.errors.length > 0) {
        this.errors = data.updateUser.errors
      }
    },
  },
}
</script>
