<template>
    <el-card class="comment">
        <h3>Comments</h3>
        <ArticleReply v-if="show_to_reply" :last_id="0" reply_to="" :pid="0" @refresh="fetchData" />
        <el-table :data="list" v-loading="loading">
            <el-table-column>
                <template #default="scope">
                    <div class="comment">
                        <div class="img">
                            <img :src="scope.row.avatar" />
                        </div>
                        <div class="info">
                            <div class="name">
                                <a :href="scope.row.url" target="_blank">
                                    {{ scope.row.name }}
                                </a>
                            </div>
                            <div>
                                <span class="time">{{ getNowFormatDate(scope.row.create_time) }}</span>
                                <el-button class="reply-btn" type="text"
                                    @click="replyBtn(scope.$index, scope.row)">REPLY</el-button>
                            </div>
                        </div>
                        <div class="content">
                            <v-md-preview :text="scope.row.content"></v-md-preview>
                        </div>
                        <ArticleReply v-if="scope.row.reply" :last_id="last_id" :reply_to="reply_to" :pid="scope.row.id"
                            @cancel="cancelBtn($index)" @refresh="refresh()" />
                    </div>
                    <div v-if="scope.row.childs" class="sub-comment">
                        <div class="sub-comment-item" v-for="(item, index) in scope.row.childs" :key="index">
                            <div class="img">
                                <img :src="item.avatar" />
                            </div>
                            <div class="info">
                                <div class="name">
                                    <a :href="item.url" target="_blank">
                                        {{ item.name }}
                                    </a>
                                </div>
                                <div>
                                    <span class="time">{{ getNowFormatDate(item.create_time) }}</span>
                                    <el-button class="reply-btn" type="text"
                                        @click="replyBtn(index, item, scope.$index)">REPLY</el-button>
                                </div>
                            </div>
                            <div class="content">
                                <v-md-preview :text="item.content"></v-md-preview>
                            </div>
                            <ArticleReply v-if="item.reply" :last_id="last_id" :reply_to="reply_to" :pid="scope.row.id"
                                @cancel="cancelBtn($index, index)" @refresh="refresh()" />
                        </div>
                    </div>
                </template>
            </el-table-column>
        </el-table>
        <div style="text-align: center">
            <el-pagination layout="total, prev, pager, next" @current-change="fetchData" :page-size="pagination.page_size"
                :total="pagination.total">
            </el-pagination>
        </div>
    </el-card>
</template>

<script setup>
// Vue3必备
// 预览组件以及样式
import VMdPreview from '@kangc/v-md-editor/lib/preview';
import '@kangc/v-md-editor/lib/style/preview.css';
// VuePress主题以及样式（这里也可以选择github主题）
import vuepressTheme from '@kangc/v-md-editor/lib/theme/vuepress.js';
import '@kangc/v-md-editor/lib/theme/style/vuepress.css';

// Prism
import Prism from 'prismjs';
// 代码高亮
import 'prismjs/components/prism-json';
// 选择使用主题
VMdPreview.use(vuepressTheme, {
    Prism,
});

const props = defineProps(['id'])

const route = useRoute()

const id = props.id
const loading = ref(false)
const list = ref([])
const pagination = ref({
    total: 0,
    page_size: 6
})
const show_to_reply = ref(true)
const reply_to = ref('')
const last_ids = ref([])
const last_id = ref(0)
const current_page = ref(0)

const fetchData = async (page = 1) => {
    loading.value = true

    let url = `/api/comments?article_id=${route.params.id}&last_id=${last_ids.value[page] ?? 0}`
    const {
        data
    } = await useHttpGet('/api/comments', url, {});
    if (data.value) {
        format(data.value, page)
    }
    loading.value = false
}

const fetchTotal = async () => {
    const {
        data
    } = await useHttpGet('/api/comments/count', `/api/comments/count?article_id=${route.params.id}`, {});
    if (data.value) {
        pagination.value.total = data.value.count;
    }
}

const replyBtn = (index, row, parent_index = -1) => {
    reply_to.value = `@${row.name}`;
    show_to_reply.value = false;
    list.value.forEach((el) => {
        el?.childs.forEach((e) => {
            e.reply = false;
            return e;
        })
        el.reply = false;
        return el;
    });
    row.reply = true;
    if (parent_index > -1) {
        list.value[parent_index].childs[index] = row;
    } else {
        // $set(list, index, row);
    }
}
const cancelBtn = (i, j = -1) => {
    // if (j < 0) {
    //     list[i].reply = false;
    // } else {
    //     list[i].childs[j].reply = false;
    // }
    // reply_to.value = '';
    // show_to_reply = true;
}
const format = (res, page) => {
    if (!res.length) {
        return;
    }
    res.forEach((el) => {
        el.reply = false;
        return el;
    });
    last_id.value = last_ids.value[page] = res[res.length - 1].id;
    let del_ids = [];
    list.value = [];
    list.value = res.map((el) => {
        el.childs = res.filter((e) => {
            if (e.pid === el.id) {
                del_ids.push(e.id);
                return true;
            }
            return false;
        });
        return el;
    }).filter((el) => {
        return !del_ids.find((e) => {
            return e === el.id;
        });
    });
}
const getNowFormatDate = (timestamp) => {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hour = date.getHours() < 10 ? `0${date.getHours()}` : date.getHours()
    const minute = date.getMinutes() < 10 ? `0${date.getMinutes()}` : date.getMinutes()
    const second = date.getSeconds() < 10 ? `0${date.getSeconds()}` : date.getSeconds()
    return `${year}-${month}-${day} ${hour}:${minute}:${second}`
}
const refresh = () => {
    // window.location.reload();
}

useAsyncData(fetchData)
useAsyncData(fetchTotal)
</script>

<style lang="scss" scoped>
.comment {
    margin-top: 30px;

    .comment:hover,
    .sub-comment-item:hover {
        .info {
            .reply-btn {
                opacity: 1;
            }
        }
    }

    .img {
        background: rgba(0, 0, 0, 0);
        float: left;
        width: 40px;
        height: 40px;
        margin-right: 10px;

        img {
            width: 41px;
            height: 41px;
            border-radius: 50%;
        }
    }

    .info {
        margin-left: 10px;

        .name {
            a {
                font-size: 16px;
                font-weight: bold;
            }
        }

        .reply-btn {
            font-size: 12px;
            display: block;
            margin-left: 10px;
            float: right;
            color: #fff;
            background-color: #e2684a;
            line-height: 20px;
            padding: 0 6px;
            border-radius: 3px;
            opacity: 0;
        }
    }

    .content {
        margin-top: 15px;
        font-size: 14px;
        line-height: 30px;
        color: #63686d;
    }

    .sub-comment {
        display: block;
        margin-left: 80px;

        .sub-comment-item {
            border-top: 1px solid #ccc;
            padding-top: 30px;
        }
    }
}
</style>
