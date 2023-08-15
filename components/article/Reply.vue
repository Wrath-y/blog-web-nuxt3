<template>
    <div class="reply">
        <div class="user-info">
            <el-input v-model="form.name" placeholder="昵称(选填)" />
            <el-input style="margin: 0 10px" v-model="form.email" placeholder="邮箱(选填,用于获取gravatar头像)" />
            <el-input v-model="form.url" placeholder="网站(选填)" />
        </div>
        <div class="content">
            <el-input type="textarea" :autosize="{ minRows: 6 }" placeholder="你有什么想对我说的..." v-model="form.content" />
        </div>
        <div class="buttom-btn">
            <el-button class="submit-btn" @click="submit">COMMIT</el-button>
            <el-button v-if="pid" class="cancel-btn" @click="$emit('cancel')">CANCEL</el-button>
        </div>
    </div>
</template>

<script setup>
import { ElMessage } from 'element-plus'

const props = defineProps(['last_id', 'reply_to', 'pid'])
const route = useRoute()
const emit = defineEmits(['cancel', 'refresh'])

const loading = ref(false)
const form = ref({
    last_id: props.last_id || 0,
    name: '',
    email: '',
    url: '',
    content: props.reply_to ? props.reply_to + '  ' : '',
    article_id: Number(route.params.id),
    pid: props.pid || 0,
})

const submit = async () => {
    loading.value = true

    if (!form.value.content) {
        ElMessage.error('不能发空消息哦~')
        return;
    }

    let body = form.value
    const {
        data
    } = await useHttpPost("/api/comments", `/api/comments`, { body });
    if (data.value) {
        ElMessage.success('提交成功')
    }
    loading.value = false
    emit('cancel')
    emit('refresh')
}
</script>
<style lang="scss" scoped>
.reply {
    margin-top: 15px;

    .user-info {
        display: flex;
        justify-content: center;
    }

    .content {
        margin-top: 10px;
    }

    .buttom-btn {
        display: flex;
        justify-content: space-between;
        margin-top: 10px;
    }
}
</style>

