export default {
  async sleep(time: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, time))
  },
  closeNotification(): void {
    this.notifications = []
  },
}
