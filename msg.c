#include "global.h"

#define MAX_HANDLER 30

struct Handler Handler_List[MAX_HANDLER];
int n_handlers = 0;

void add_handler(const char *name, void (*handler)(int,struct Msg*))
{
        if(n_handlers < MAX_HANDLER)
        {
                strncpy(Handler_List[n_handlers].cmd, name, MAX_CMD_LEN);
                Handler_List[n_handlers].handler = handler;
                n_handlers++;
        }
}
static void handle_msg(int fd, struct Msg *msg)
{
        fprintf (stderr, "%s: n_handlers %d\n", __func__, n_handlers);
        int i;
        for(i = 0; i < n_handlers; i++)
        {
                fprintf(stderr, "Comparing {%s} and {%s}\n", msg->cmd, Handler_List[i].cmd);
                if(!strcmp(msg->cmd, Handler_List[i].cmd))
                {
                        fprintf(stderr, "Executing %s\n", msg->cmd);
                        Handler_List[i].handler(fd, msg);
                        break;
                }
        }
        if (i == n_handlers)
        {
                fprintf (stderr, "Executing nothing n_handlers %d\n", n_handlers);
        }
}
static void parse_msg(char *data, struct Msg *msg)
{
        char *ptr;
        int start_by_cmd = 1;
        if(*data == ':')
        {
                start_by_cmd = 0;
                data++;
        }
        ptr = data;
        while(*data)
        {
                if(*data == ':')
                {
                        strncpy(msg->data, data+1, MAX_DATA_LEN);
                        break;
                }
                else if(*data == ' ')
                {
                        *data = 0;
                        if(msg->from[0] == 0 && !start_by_cmd)
                        {
                                strncpy(msg->from, ptr, MAX_FROM_LEN);
                        }
                        else if(msg->cmd[0] == 0)
                        {
                                strncpy(msg->cmd, ptr, MAX_CMD_LEN);
                        }
                        else
                        {
                                strncpy(msg->to, ptr, MAX_TO_LEN);
                        }
                        ptr = data + 1;
                }
                data++;
        }
        printf("CMD    = '%s'\n", msg->cmd);
        printf("TO     = '%s'\n", msg->to);
        printf("FROM   = '%s'\n", msg->from);
        printf("DATA   = '%s'\n", msg->data);
}
void handle_data(int fd, char *data, int len)
{
        int cur, start;
        struct Msg msg;

        for(cur = 0, start = 0; cur < len-1; cur++)
        {
                if(data[cur] == '\r' && data[cur+1] == '\n')
                {
                        data[cur] = '\0';
                        printf("<== %s\n", data + start);
                        memset(&msg, 0, sizeof(struct Msg));
                        parse_msg(data + start, &msg);
                        handle_msg(fd, &msg);
                        start = cur + 2;
                }
        }
}
