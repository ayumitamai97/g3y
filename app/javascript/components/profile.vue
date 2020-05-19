<template>
  <div class='container'>
    <h2 class='title is-size-2 has-text-grey-dark'>
      Your Profile
    </h2>
    <errors :errors='errors' />
    <successes :successes='notifications' />
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
</template>

<script lang='ts'>
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
    }
  },
  methods: {
    upload(event): void {
      const { userName } = this.$store.state
      const requestObject: object = {
        Key: `icons/${userName}_${Date.now()}.jpg`,
        Bucket: process.env.AWS_BUCKET,
        Body: event.target.files[0],
      }
      const callback: object = (err) => {
        if (err) {
          this.errors.push(err)
        } else {
          this.notifications.push('Successfully uploaded image')
        }
      }
      this.$s3.putObject(requestObject, callback)
    },
  },
}
</script>
