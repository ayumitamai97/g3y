<template>
  <div
    v-if='errors.length > 0'
    class='notification is-danger'
  >
    <button
      class='delete m-10'
      @click='closeNotification'
    />
    <div
      v-for='error in errors'
      :key='error'
    >
      <p>{{ error }}</p>
    </div>
  </div>
</template>

<script lang='ts'>
import util from '../src/util.ts'

export default {
  props: {
    errors: {
      type: Array,
      default: (): string[] => [],
    },
  },
  data(): object {
    return {
      notifications: this.errors,
    }
  },
  created(): void {
    this.closeNotification = util.closeNotification.bind(this)
  },
}
</script>
